// SPDX-License-Identifier: {{license}}
pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract {{contractName}} is Ownable {
    struct Product {
        uint256 price;
        bool exists;
    }

    mapping (address => mapping(bytes32 => bool)) public subscriptions;
    mapping (bytes32 => Product) public products;

    event ProductAdded(bytes32 indexed productId, uint256 price);
    event Subscribed(address indexed user, bytes32 indexed productId);

    function addProduct(bytes32 productId, uint256 price) public onlyOwner {
        require(!products[productId].exists, "Product already exists");
        require(price > 0, "Price should be greater than 0");

        products[productId] = Product(price, true);

        emit ProductAdded(productId, price);
    }

    function subscribe(bytes32 productId) public payable {
        require(products[productId].exists, "Product does not exist");
        require(msg.value == products[productId].price, "Incorrect value sent");

        subscriptions[msg.sender][productId] = true;

        emit Subscribed(msg.sender, productId);
    }

    function isSubscribed(address user, bytes32 productId) public view returns (bool) {
        return subscriptions[user][productId];
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
