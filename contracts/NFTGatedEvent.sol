// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNFT is ERC721, Ownable {
    // Token ID counter for unique tokens
    uint256 private _tokenIdCounter;

    // Constructor to initialize the NFT collection
    constructor(string memory name, string memory symbol) ERC721(name, symbol) Ownable(msg.sender) {
        _tokenIdCounter = 0; // Start token IDs at 0
    }

    // Function to safely mint a new NFT
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);
    }

    // Function to get all tokenIds owned by a specific user
    function tokensOwnedBy(address user) public view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(user);
        uint256[] memory ownedTokenIds = new uint256[](tokenCount);
        uint256 counter = 0;

        // Loop through all minted tokens and find the ones owned by the user
        for (uint256 i = 0; i < _tokenIdCounter; i++) {
            if (ownerOf(i) == user) {
                ownedTokenIds[counter] = i;
                counter++;
            }
        }

        return ownedTokenIds;
    }

    // Function to check if a user owns a specific NFT
    function verifyOwnership(address user, uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) == user;
    }

    // Function to grant access to the event based on NFT ownership
    function grantEventAccess(address user, uint256 tokenId) public view returns (string memory) {
        // Check if the user owns the specified NFT tokenId
        if (verifyOwnership(user, tokenId)) {
            return "Access Granted!";
        } else {
            return "Access Denied!";
        }
    }
}
