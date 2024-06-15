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
    }

    mapping(address => ProposedCampaign) private proposedCampaigns;
    uint256 public totalManagerTokens;

    address[] private proposedCampaigns;
    address[] private listedCampaigns;

    event CampaignCreated(address indexed campaignAddress, address indexed creator, uint256 goal, uint256 deadline);
    event CampaignApproved(address indexed campaignAddress, address indexed approver, uint256 approvals);

    constructor(address[] memory initialRecipients, uint256[] memory initialAmounts) {
        require(initialRecipients.length == initialAmounts.length, "Recipients and amounts length mismatch");

        managerToken = new ManagerToken();
        totalManagerTokens = managerToken.totalSupply();

        for (uint256 i = 0; i < initialRecipients.length; i++) {
            managerToken.transfer(initialRecipients[i], initialAmounts[i]);
        }
    }

    function createCampaign(uint256 goal, uint256 deadline) external returns (address) {
        Campaign campaign = new Campaign(msg.sender, goal, deadline, address(managerToken));
        address campaignAddress = address(campaign);

        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        proposal.campaign = campaignAddress;
        proposedCampaigns.push(campaignAddress);

        emit CampaignCreated(campaignAddress, msg.sender, goal, deadline);

        return campaignAddress;
    }

    function approveCampaign(address campaignAddress) external {
        require(managerToken.balanceOf(msg.sender) > 0, "Only managers can approve campaigns");

        ProposedCampaign storage proposal = proposedCampaigns[campaignAddress];
        require(proposal.campaign != address(0), "Campaign does not exist");
        require(!proposal.approvedBy[msg.sender], "Manager already approved this campaign");

        proposal.approvedBy[msg.sender] = true;
        proposal.approvals += managerToken.balanceOf(msg.sender);

        emit CampaignApproved(campaignAddress, msg.sender, proposal.approvals);

        if (isCampaignApproved(campaignAddress)) {
            listedCampaigns.push(campaignAddress);
            removeProposedCampaign(campaignAddress);
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
        return proposedCampaigns;
    }

    function removeProposedCampaign(address campaignAddress) internal {
        for (uint256 i = 0; i < proposedCampaigns.length; i++) {
            if (proposedCampaigns[i] == campaignAddress) {
                proposedCampaigns[i] = proposedCampaigns[proposedCampaigns.length - 1];
                proposedCampaigns.pop();
                break;
            }
        }
    }
}
