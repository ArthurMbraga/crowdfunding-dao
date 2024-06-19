// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CampaignToken is ERC20 {
    address public campaignAddress;

    constructor(address _campaignAddress) ERC20("CampaignToken", "CPK") {
        campaignAddress = _campaignAddress;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == campaignAddress, "Only campaign can mint tokens");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == campaignAddress, "Only campaign can burn tokens");
        _burn(from, amount);
    }
}
