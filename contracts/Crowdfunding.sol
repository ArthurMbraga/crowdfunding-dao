// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Crowfunding {
    struct Campaign {
        uint256 amountCollected;
        mapping(address => uint256) funders;
        uint256 deadline;
        uint256 targetFounds;
        string title;
        address owner;
        bool fundsWithdrawn;
    }
    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    event Funded(uint256 _id, address _funder, uint256 _amount);
    event OwnerWithdraw(uint256 _id, uint256 _amount);
    event FunderWithdraw(uint256 _id, address _funder, uint256 _amount);

    function createCampaign(
        string memory _title,
        uint256 _targetFunds,
        uint256 _deadline
    ) public returns (uint256) {
        uint256 campaignId = numberOfCampaigns;

        Campaign storage campaign = campaigns[campaignId];

        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future."
        );

        campaign.owner = msg.sender;
        campaign.title = _title;
        campaign.targetFounds = _targetFunds;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;

        numberOfCampaigns++;

        return campaignId;
<<<<<<< HEAD
    ***REMOVED***
=======
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function donateToCampaign(uint256 _id) public payable {
        require(isFundEnabled(_id) == true, "Fund is now disabled!");

        Campaign storage campaign = campaigns[_id];
        uint256 amount = msg.value;

        campaign.funders[msg.sender] += amount;
        campaign.amountCollected = campaign.amountCollected + amount;
        emit Funded(_id, msg.sender, amount);
<<<<<<< HEAD
    ***REMOVED***
=======
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function getDonators(uint256 _id) public view returns (uint256[] memory) {
        uint256[] memory donators = new uint256[](numberOfCampaigns);
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            donators[i] = campaigns[_id].funders[msg.sender];
<<<<<<< HEAD
        ***REMOVED***
        return donators;
    ***REMOVED***
=======
        }
        return donators;
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function getCampaigns()
        public
        view
        returns (uint256[] memory, string[] memory)
    {
        uint256[] memory ids = new uint256[](numberOfCampaigns);
        string[] memory titles = new string[](numberOfCampaigns);

        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage campaign = campaigns[i];
            ids[i] = i;
            titles[i] = campaign.title;
<<<<<<< HEAD
        ***REMOVED***

        return (ids, titles);
    ***REMOVED***
=======
        }

        return (ids, titles);
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function withdrawOwner(uint256 _id) public {
        Campaign storage campaign = campaigns[_id];

        require(msg.sender == campaign.owner, "Only owner can withdraw funds!");
        require(isFundSucccess(_id) == true, "Funds not yet reached target!");

        uint256 amountToSend = address(this).balance;
<<<<<<< HEAD
        (bool success, ) = msg.sender.call{value: amountToSend***REMOVED***("");
=======
        (bool success, ) = msg.sender.call{value: amountToSend}("");
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
        require(success, "Failed to send funds to owner!");
        campaign.fundsWithdrawn = true;

        emit OwnerWithdraw(_id, amountToSend);
<<<<<<< HEAD
    ***REMOVED***
=======
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function withdrawFunder(uint256 _id) public {
        require(
            isFundEnabled(_id) == false && isFundSucccess(_id) == false,
            "Fund is still enabled or funds reached target!"
        );

        Campaign storage campaign = campaigns[_id];

        uint256 amountToSend = campaign.funders[msg.sender];
<<<<<<< HEAD
        (bool success, ) = msg.sender.call{value: amountToSend***REMOVED***("");
        require(success, "Failed to send funds to funder!");
        campaign.funders[msg.sender] = 0;
        emit FunderWithdraw(_id, msg.sender, amountToSend);
    ***REMOVED***
=======
        (bool success, ) = msg.sender.call{value: amountToSend}("");
        require(success, "Failed to send funds to funder!");
        campaign.funders[msg.sender] = 0;
        emit FunderWithdraw(_id, msg.sender, amountToSend);
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function isFundEnabled(uint256 _id) public view returns (bool) {
        Campaign storage campaign = campaigns[_id];

        if (block.timestamp > campaign.deadline || campaign.fundsWithdrawn) {
            return false;
<<<<<<< HEAD
        ***REMOVED*** else {
            return true;
        ***REMOVED***
    ***REMOVED***
=======
        } else {
            return true;
        }
    }
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    function isFundSucccess(uint256 _id) public view returns (bool) {
        Campaign storage campaign = campaigns[_id];

        if (
            address(this).balance >= campaign.targetFounds ||
            campaign.fundsWithdrawn
        ) {
            return true;
<<<<<<< HEAD
        ***REMOVED*** else {
            return false;
        ***REMOVED***
    ***REMOVED***
***REMOVED***
=======
        } else {
            return false;
        }
    }
}
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
