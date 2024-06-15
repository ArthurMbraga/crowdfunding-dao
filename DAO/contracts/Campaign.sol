// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CampaignToken.sol";

contract Campaign {
    address public owner;
    string  public title;
    uint256 public goal;
    uint256 public deadline;
    uint256 public fundsRaised;
    bool    public fundsWithdrawn;
    CampaignToken public campaignToken;
    IERC20 public managerToken;
    address public dao;

    mapping(address => uint256) funders;
     address[] public funderAddresses;

    event CampaignCreated(address indexed owner, uint256 goal, uint256 deadline);
    event FundMade(address indexed contributor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event TokensConverted(address indexed contributor, uint256 amount);
    event RefundIssued(address indexed funder, uint256 amount);

    constructor(
        address _owner,
        string  memory _title,
        uint256 _goal,
        uint256 _deadline,
        address _managerToken,
        address _dao
    ) {
        owner = _owner;
        title = _title;
        goal = _goal;
        deadline = block.timestamp + _deadline;
        fundsRaised = 0;
        fundsWithdrawn = false;
        campaignToken = new CampaignToken(address(this));
        managerToken = IERC20(_managerToken);
        dao = _dao;

        emit CampaignCreated(_owner, _goal, deadline);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyDAO() {
        require(msg.sender == dao, "Only DAO can call this function");
        _;
    }

    function donate(address funder) external payable onlyDAO {
        if (funders[funder] == 0) {
            funderAddresses.push(funder);
        }
        require(block.timestamp < deadline, "Funding period is over");
        require(msg.value > 0, "Fund must be greater than zero");

        fundsRaised += msg.value;
        funders[funder] += msg.value;
        campaignToken.mint(funder, msg.value);

        emit FundMade(funder, msg.value);
    }

    function withdrawFunds() external onlyOwner {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised >= goal, "Funding goal not reached");
        require(!fundsWithdrawn, "Funds already withdrawn");

        fundsWithdrawn = true;
        payable(owner).transfer(fundsRaised);

        emit FundsWithdrawn(owner, fundsRaised);
    }

    function convertToManagerTokens() external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised < goal, "Funding goal was reached");

        uint256 balance = campaignToken.balanceOf(msg.sender);
        require(balance > 0, "No campaign tokens to convert");

        campaignToken.burn(msg.sender, balance);
        managerToken.transfer(msg.sender, balance);

        emit TokensConverted(msg.sender, balance);
    }

    function refund() external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised < goal, "Funding goal was reached");

        uint256 fund = funders[msg.sender];
        require(fund > 0, "No funds to refund");

        funders[msg.sender] = 0;
        payable(msg.sender).transfer(fund);

        emit RefundIssued(msg.sender, fund);
    }

    function getDeadline() external view returns (uint256) {
        return deadline;
    }

    function isFundsWithdrawn() external view returns (bool) {
        return fundsWithdrawn;
    }

    function getFundsRaised() external view returns (uint256) {
        return fundsRaised;
    }

    function getGoal() external view returns (uint256) {
        return goal;
    }

    function getFunders() external view returns (address[] memory) {
        return funderAddresses;
    }
}
