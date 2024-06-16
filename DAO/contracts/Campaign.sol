// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CampaignToken.sol";

contract Campaign {
    address public owner;
    string public title;
    uint256 public goal;
    uint256 public deadline;
    uint256 public fundsRaised;
    bool public fundsWithdrawn;
    bool public votingActive;
    bool public fundsReleaseApproved = false;
    bool public refundDecided = false;
    CampaignToken public campaignToken;
    IERC20 public managerToken;
    address public dao;

    mapping(address => uint256) public funders;
    address[] public funderAddresses;

    mapping(address => bool) public votes;
    uint256 public votesForRelease;
    uint256 public votesAgainstRelease;

    uint256 public totalCampaignTokens;

    uint256 public votingStartTime;

    event CampaignCreated(
        address indexed owner,
        uint256 goal,
        uint256 deadline
    );
    event FundMade(address indexed contributor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event TokensConverted(address indexed contributor, uint256 amount);
    event RefundIssued(address indexed funder, uint256 amount);
    event VoteStarted();
    event VoteCast(address indexed voter, bool vote);
    event VoteEnded(bool fundsReleased);

    constructor(
        address _owner,
        string memory _title,
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
        votingActive = false;
        campaignToken = new CampaignToken(address(this));
        managerToken = IERC20(_managerToken);
        dao = _dao;

        totalCampaignTokens = campaignToken.totalSupply();

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

        totalCampaignTokens = campaignToken.totalSupply();

        emit FundMade(funder, msg.value);
    }

    function startVote() internal {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised >= goal, "Funding goal not reached");
        require(!votingActive, "Voting already active");

        votingActive = true;
        votesForRelease = 0;
        votesAgainstRelease = 0;
        votingStartTime = block.timestamp;

        emit VoteStarted();
    }

    function vote(bool releaseFunds, address voter) external {
        require(votingActive, "No active voting");
        require(campaignToken.balanceOf(voter) > 0, "No tokens to vote");
        require(!votes[voter], "Already voted");

        votes[voter] = true;

        if (releaseFunds) {
            votesForRelease += campaignToken.balanceOf(voter);
        } else {
            votesAgainstRelease += campaignToken.balanceOf(voter);
        }

        isVoteEnded();

        emit VoteCast(voter, releaseFunds);
    }

    function isVoteEnded() public {
        if (!votingActive) {
            return;
        }

        bool fundsReleased = votesForRelease > totalCampaignTokens / 2;
        bool fundsNotReleased = votesAgainstRelease >= totalCampaignTokens / 2;

        if (
            fundsNotReleased || block.timestamp >= votingStartTime + 3 minutes
        ) {
            votingActive = false;
        } else if (fundsReleased) {
            fundsWithdrawn = true;
            fundsReleaseApproved = true;
            payable(owner).transfer(fundsRaised);
            votingActive = false;

            emit FundsWithdrawn(owner, fundsRaised);
        }

        emit VoteEnded(fundsReleased);
    }

    function withdrawFunds() external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised >= goal, "Funding goal not reached");
        require(!fundsWithdrawn, "Funds already withdrawn");

        if (!votingActive && !fundsReleaseApproved && !refundDecided) {
            startVote();
        } else if (fundsReleaseApproved) {
            fundsWithdrawn = true;
            payable(owner).transfer(fundsRaised);
            fundsReleaseApproved = false;
            emit FundsWithdrawn(owner, fundsRaised);
        }
    }

    function convertToManagerTokens(address funder) external {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        require(fundsRaised > goal, "Funding goal was reached");

        uint256 balance = campaignToken.balanceOf(funder);
        require(balance > 0, "No campaign tokens to convert");

        campaignToken.burn(funder, balance);
        managerToken.transfer(funder, balance);

        emit TokensConverted(funder, balance);
    }

    function refund(address funder) external {
        if (!refundDecided) {
            require(
                block.timestamp >= deadline,
                "Funding period is not over yet"
            );
            require(fundsRaised < goal, "Funding goal was reached");

            uint256 fund = funders[funder];
            require(fund > 0, "No funds to refund");

            funders[funder] = 0;
            payable(funder).transfer(fund);

            emit RefundIssued(funder, fund);
        }
        else 
        {
            require(funders[funder] > 0, "No funds to refund");
            uint256 fund = funders[funder];
            funders[funder] = 0;
            payable(funder).transfer(fund);

            emit RefundIssued(funder, fund);
        }
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

    function getOwner() external view returns (address) {
        return owner;
    }

    function getFunders() external view returns (address[] memory) {
        return funderAddresses;
    }
}
