// SPDX-License-Identifier: {{license}}
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract {{contractName}} is ERC20 {
    constructor(uint256 initialSupply) ERC20("{{tokenName}}", "{{symbol}}") {
        _mint(msg.sender, initialSupply);
    }
}