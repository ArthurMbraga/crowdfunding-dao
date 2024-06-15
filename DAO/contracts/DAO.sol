// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ManagerToken.sol";
import "./Campaign.sol";

contract DAO {
    ManagerToken public managerToken;

    struct ProposedCampaign {
        address campaign;
        uint256 approvals;
        mapping(address => bool) approvedBy;
        uint256 creationTime;
    }

    mapping(address => ProposedCampaign) private proposedCampaigns;
    uint256 public totalManagerTokens;

    address[] private proposedCampaignsList;
    address[] private listedCampaigns;
    address[] private rejectedCampaigns;
    address[] private successfulCampaigns;
    address[] private failedCampaigns;

    event CampaignCreated(address indexed campaignAddress, address indexed creator, uint256 goal, uint256 deadline);
    event CampaignApproved(address indexed campaignAddress, address indexed approver, uint256 approvals);
    event CampaignRejected(address indexed campaignAddress);

    constructor(address[] memory initialRecipients, uint256[] memory initialAmounts) {
        require(initialRecipients.length == initialAmounts.length, "Recipients and amounts length mismatch");

        managerToken = new ManagerToken();
        totalManagerTokens = managerToken.totalSupply();

        for (uint256 i = 0; i < initialRecipients.length; i++) {
            managerToken.transfer(initialRecipients[i], initialAmounts[i]);
        }
    }

    function createCampaign(string memory title, uint256 goal, uint256 deadline) external returns (address) {
        require(goal > 0, "Goal must be greater than zero");
        require(deadline > 0, "Deadline must be greater than zero");

        Campaign campaign = new Campaign(msg.sender, title, goal, deadline, address(managerToken), address(this));
        address campaignAddress = address(campaign);

        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        proposal.campaign = campaignAddress;
        proposal.creationTime = block.timestamp;
        proposedCampaignsList.push(campaignAddress);

        emit CampaignCreated(campaignAddress, msg.sender, goal, deadline);

        return campaignAddress;
    }

    function approveCampaign(address campaignAddress) external {
        require(managerToken.balanceOf(msg.sender) > 0, "Only managers can approve campaigns");
        checkAndExpire(campaignAddress);
        require(isCampaignInList(campaignAddress, proposedCampaignsList), "Campaign is not in proposed campaigns list");

        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        require(proposal.campaign != address(0), "Campaign does not exist");
        require(!proposal.approvedBy[msg.sender], "Manager already approved this campaign");

        proposal.approvedBy[msg.sender] = true;
        proposal.approvals += managerToken.balanceOf(msg.sender);

        emit CampaignApproved(campaignAddress, msg.sender, proposal.approvals);

        if (isCampaignApproved(campaignAddress)) {
            listedCampaigns.push(campaignAddress);
            removeCampaignFromList(campaignAddress, proposedCampaignsList);
        }
    }

    function fundCampaign(address campaignAddress) external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        require(isCampaignInList(campaignAddress, listedCampaigns), "Campaign is not listed");
        Campaign campaign = Campaign(campaignAddress);
        require(isFundEnabled(campaign), "Campaign is not accepting funds");

        campaign.donate{value: msg.value}(msg.sender);
    }

    function isFundEnabled(Campaign campaign) internal returns (bool) {
        if (block.timestamp > campaign.getDeadline() || campaign.isFundsWithdrawn()) {
            if (campaign.getFundsRaised() < campaign.getGoal()) {
                failedCampaigns.push(address(campaign));
            } else {
                successfulCampaigns.push(address(campaign));
            }
            removeCampaignFromList(address(campaign), listedCampaigns);
            return false;
        } else {
            return true;
        }
    }

    function isCampaignApproved(address campaignAddress) public view returns (bool) {
        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        return proposal.approvals >= (totalManagerTokens * 66) / 100;
    }

    function getProposedCampaign(address campaignAddress) public view returns (address, uint256) {
        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        return (proposal.campaign, proposal.approvals);
    }

    function getListedCampaigns() public view returns (address[] memory) {
        return listedCampaigns;
    }

    function getProposedCampaigns() public view returns (address[] memory) {
        return proposedCampaignsList;
    }

    function getRejectedCampaigns() public view returns (address[] memory) {
        return rejectedCampaigns;
    }

    function removeCampaignFromList(address campaignAddress, address[] storage list) internal {
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == campaignAddress) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }

    function checkAndRejectExpiredProposals() external {
        for (uint256 i = proposedCampaignsList.length; i > 0; i--) {
        address campaignAddress = proposedCampaignsList[i - 1];
        checkAndExpire(campaignAddress);
    }
    }

    function checkAndExpire(address campaignAddress) internal {
        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        require(proposal.campaign != address(0), "Campaign does not exist");
        require(!isCampaignApproved(campaignAddress), "Campaign is already approved");

        if (block.timestamp > proposal.creationTime + 5 minutes) {
            rejectedCampaigns.push(campaignAddress);
            removeCampaignFromList(campaignAddress, proposedCampaignsList);
            emit CampaignRejected(campaignAddress);
        }
    }    

    function isCampaignInList(address campaignAddress, address[] memory list) internal pure returns (bool) {
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == campaignAddress) {
                return true;
            }
        }
        return false;
    }

    function getSuccessfulCampaigns() public view returns (address[] memory) {
        return successfulCampaigns;
    }

    function getFailedCampaigns() public view returns (address[] memory) {
        return failedCampaigns;
    }

    function getCampaignFunders(address campaignAddress) public view returns (address[] memory) {
        Campaign campaign = Campaign(campaignAddress);
        return campaign.getFunders();
    }

    function getCampaignFundsRaised(address campaignAddress) public view returns (uint256) {
        Campaign campaign = Campaign(campaignAddress);
        return campaign.getFundsRaised();
    }

    function refund(address campaignAddress) public {
        require(isCampaignInList(campaignAddress, failedCampaigns), "Campaign is not failed");
        Campaign campaign = Campaign(campaignAddress);
        campaign.refund();
    }

}
