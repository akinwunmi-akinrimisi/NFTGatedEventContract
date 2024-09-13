// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNFT is ERC721, Ownable {
    // Token ID counter for unique tokens
    uint256 private _tokenIdCounter;

    // Maximum supply of NFTs
    uint256 public maxSupply;

    // Mapping to track whether a user has already minted an NFT
    mapping(address => bool) public hasMinted;

    // Mapping to track all tokens owned by each user
    mapping(address => uint256[]) private ownedTokens;

    // Constructor to initialize the NFT collection with a custom max supply
    constructor(string memory name, string memory symbol, uint256 _maxSupply) ERC721(name, symbol) Ownable(msg.sender) {
        require(_maxSupply > 0, "Max supply must be greater than 0");
        maxSupply = _maxSupply;
        _tokenIdCounter = 0; // Start token IDs at 0
    }

    // Function to safely mint a new NFT with max supply and one mint per user limit
    function safeMint(address to) public onlyOwner {
        // Check if minting would exceed the max supply of NFTs
        require(_tokenIdCounter < maxSupply, "Max supply reached, no more NFTs can be minted");

        // Check if recipient address is valid
        require(to != address(0), "Cannot mint to the zero address");

        // Check if recipient is not a contract address using embedded logic
        uint32 size;
        assembly {
            size := extcodesize(to)
        }
        require(size == 0, "Cannot mint to a contract address");

        // Check if the user has already minted an NFT
        require(!hasMinted[to], "User has already minted an NFT");

        // Mint the new NFT
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);

        // Mark the user as having minted an NFT
        hasMinted[to] = true;

        // Add the minted tokenId to the user's list of owned tokens
        ownedTokens[to].push(tokenId);
    }

    // Function to return all tokens owned by a user or verify ownership of a specific token
    function tokensOwnedOrVerifyOwnership(address user, uint256 tokenId) public view returns (uint256[] memory, bool) {
        // Check if the user owns the specific tokenId (if tokenId is greater than 0)
        bool ownsToken = tokenId == 0 ? false : ownerOf(tokenId) == user;

        // Return the array of tokenIds owned by the user and the ownership result
        return (ownedTokens[user], ownsToken);
    }

    // Function to grant access to the event based on NFT ownership
    function grantEventAccess(address user, uint256 tokenId) public view returns (string memory) {
        // Check if the user owns the specified NFT tokenId
        (, bool ownsToken) = tokensOwnedOrVerifyOwnership(user, tokenId);
        if (ownsToken) {
            return "Access Granted!";
        } else {
            return "Access Denied!";
        }
    }
}
