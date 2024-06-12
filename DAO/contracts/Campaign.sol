// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CampaignToken.sol";

contract Campaign {
    address public creator;
    uint256 public goal;
    uint256 public deadline;
    uint256 public fundsRaised;
    CampaignToken public campaignToken;
    IERC20 public managerToken;

    mapping(address => uint256) public contributions;

    event CampaignCreated(address indexed creator, uint256 goal, uint256 deadline);
    event ContributionMade(address indexed contributor, uint256 amount);
    event FundsWithdrawn(address indexed creator, uint256 amount);
    event TokensConverted(address indexed contributor, uint256 amount);

    constructor(
        address _creator,
        uint256 _goal,
        uint256 _deadline,
        address _managerToken
    ) {
        creator = _creator;
        goal = _goal;
        deadline = block.timestamp + _deadline;
        campaignToken = new CampaignToken(address(this));
        managerToken = IERC20(_managerToken);

        emit CampaignCreated(_creator, _goal, deadline);
    ***REMOVED***

    function contribute() external payable {
        require(block.timestamp < deadline, "Funding period is over");
        require(msg.value > 0, "Contribution must be greater than zero");

        fundsRaised += msg.value;
        contributions[msg.sender] += msg.value;
        campaignToken.mint(msg.sender, msg.value);

        emit ContributionMade(msg.sender, msg.value);
    ***REMOVED***

    function withdrawFunds() external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised >= goal, "Funding goal not reached");
        require(msg.sender == creator, "Only creator can withdraw funds");

        payable(creator).transfer(fundsRaised);

        emit FundsWithdrawn(creator, fundsRaised);
    ***REMOVED***

    function convertToManagerTokens() external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised < goal, "Funding goal was reached");

        uint256 balance = campaignToken.balanceOf(msg.sender);
        require(balance > 0, "No campaign tokens to convert");

        campaignToken.burn(msg.sender, balance);
        managerToken.transfer(msg.sender, balance);

        emit TokensConverted(msg.sender, balance);
    ***REMOVED***
***REMOVED***
