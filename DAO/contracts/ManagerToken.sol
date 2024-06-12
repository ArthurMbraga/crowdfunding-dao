// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ManagerToken is ERC20 {
    constructor() ERC20("ManagerToken", "MGT") {
        _mint(msg.sender, 3000 * 10 ** decimals());
    ***REMOVED***

***REMOVED***
