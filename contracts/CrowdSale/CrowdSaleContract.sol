
// SPDX-License-Identifier: {{license}}
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract {{contractName}} is Ownable {
    ERC20 public token;
    uint256 public rate;

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    constructor(uint256 _rate, ERC20 _token) {
        require(_rate > 0);
        require(address(_token) != address(0));

        rate = _rate;
        token = _token;
    }

    receive() external payable {
        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) public payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        token.transfer(beneficiary, tokens);

        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal pure {
        require(beneficiary != address(0));
        require(weiAmount != 0);
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount * rate;
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}