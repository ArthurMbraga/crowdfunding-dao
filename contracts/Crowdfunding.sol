// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Crowfunding {
    mapping(address => uint256) public funders;
    uint256 public deadLine;
    uint256 public targetFunds;
    string public name;
    address public owner;
    bool public fundsWithdrawn;

    event Funded(address _funder, uint256 _amount);
    event OwnerWithdraw(uint256 _amount);
    event FunderWithdraw(address _funder, uint256 _amount);

    constructor(
        string memory _name,
        uint256 _targetFunds,
        uint256 _deadline
    ) public {
        owner = msg.sender;
        name = _name;
        targetFunds = _targetFunds;
        deadLine = _deadline;
    }

    function fund() public payable {
        require(isFundEnabled() == true, "Fund is now disabled!");

        funders[msg.sender] += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function withdrawOwner() public {
        require(msg.sender == owner, "Only owner can withdraw funds!");
        require(isFundSucccess() == true, "Funds not yet reached target!");

        uint256 amountToSend = address(this).balance;
        (bool success, ) = msg.sender.call{value: amountToSend}("");
        require(success, "Failed to send funds to owner!");
        fundsWithdrawn = true;
        emit OwnerWithdraw(amountToSend);
    }

    function withdrawFunder() public {
        require(
            isFundEnabled() == false && isFundSucccess() == false,
            "Fund is still enabled or funds reached target!"
        );

        uint256 amountToSend = funders[msg.sender];
        (bool success, ) = msg.sender.call{value: amountToSend}("");
        require(success, "Failed to send funds to funder!");
        funders[msg.sender] = 0;
        emit FunderWithdraw(msg.sender, amountToSend);
    }

    function isFundEnabled() public view returns (bool) {
        if (block.timestamp > deadLine || fundsWithdrawn) {
            return false;
        } else {
            return true;
        }
    }

    function isFundSucccess() public view returns (bool) {
        if (address(this).balance >= targetFunds || fundsWithdrawn) {
            return true;
        } else {
            return false;
        }
    }
}
