// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ManagerToken.sol";
import "./Campaign.sol";

contract DAO {
    ManagerToken public managerToken;

    struct CampaignProposal {
        address campaign;
        uint256 approvals;
        mapping(address => bool) approvedBy;
    ***REMOVED***

    mapping(address => CampaignProposal) public campaignProposals;
    uint256 public totalManagerTokens;

    event CampaignCreated(address indexed campaignAddress, address indexed creator, uint256 goal, uint256 deadline);
    event CampaignApproved(address indexed campaignAddress, address indexed approver, uint256 approvals);

    constructor(address[] memory initialRecipients, uint256[] memory initialAmounts) {
        require(initialRecipients.length == initialAmounts.length, "Recipients and amounts length mismatch");

        managerToken = new ManagerToken();
        totalManagerTokens = managerToken.totalSupply();

        for (uint256 i = 0; i < initialRecipients.length; i++) {
            managerToken.transfer(initialRecipients[i], initialAmounts[i]);
        ***REMOVED***
    ***REMOVED***

    function createCampaign(uint256 goal, uint256 deadline) external returns (address) {
        Campaign campaign = new Campaign(msg.sender, goal, deadline, address(managerToken));
        address campaignAddress = address(campaign);

        CampaignProposal storage proposal = campaignProposals[campaignAddress];
        proposal.campaign = campaignAddress;

        emit CampaignCreated(campaignAddress, msg.sender, goal, deadline);

        return campaignAddress;
    ***REMOVED***

    function approveCampaign(address campaignAddress) external {
        require(managerToken.balanceOf(msg.sender) > 0, "Only managers can approve campaigns");

        CampaignProposal storage proposal = campaignProposals[campaignAddress];
        require(proposal.campaign != address(0), "Campaign does not exist");
        require(!proposal.approvedBy[msg.sender], "Manager already approved this campaign");

        proposal.approvedBy[msg.sender] = true;
        proposal.approvals += managerToken.balanceOf(msg.sender);

        emit CampaignApproved(campaignAddress, msg.sender, proposal.approvals);

        if (isCampaignApproved(campaignAddress)) {
            approvedCampaigns[campaignAddress] = true;
        ***REMOVED***
    ***REMOVED***

    function isCampaignApproved(address campaignAddress) public view returns (bool) {
        CampaignProposal storage proposal = campaignProposals[campaignAddress];
        return proposal.approvals >= (totalManagerTokens * 66) / 100;
    ***REMOVED***

    mapping(address => bool) public approvedCampaigns;
***REMOVED***
