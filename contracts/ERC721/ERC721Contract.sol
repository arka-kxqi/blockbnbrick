// SPDX-License-Identifier: {{license}}
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract {{contractName}} is ERC721, ERC721Enumerable, Ownable {
    string private _baseTokenURI;
    uint256 private _tokenIdCounter;

    constructor(string memory baseTokenURI) ERC721("{{tokenName}}", "{{symbol}}") {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
        internal
        virtual
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Public function to expose the base URI
    function baseURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    // Minting function restricted to the owner
    function mint() public onlyOwner {
        _mint(msg.sender, _tokenIdCounter);
        _tokenIdCounter++;
    }
}