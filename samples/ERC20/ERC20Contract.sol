// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Contract is ERC20 {
    constructor(uint256 initialSupply) ERC20("MySampleToken", "MST") {
        _mint(msg.sender, initialSupply);
    }
}
