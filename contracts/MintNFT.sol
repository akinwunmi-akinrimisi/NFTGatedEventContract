// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintingNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    uint256 public maxSupply;
    // address public owner;

    // Mapping to store metadata URIs for each token
    mapping(uint256 => string) private _tokenURIs;

    // Custom mapping to track token existence (instead of using _exists)
    mapping(uint256 => bool) private _tokenExists;
    event Minted(address indexed to, uint256 indexed tokenId, string uri);

    constructor(string memory name, string memory symbol, uint256 _maxSupply) ERC721(name, symbol) Ownable(msg.sender){
        require(_maxSupply > 0, "Max supply must be greater than 0");
        require(bytes(name).length > 0, "Token name cannot be empty");
        require(bytes(symbol).length > 0, "Token symbol cannot be empty");
        require(msg.sender != address(0), "address zero not allowed");

        maxSupply = _maxSupply;
        _tokenIdCounter = 0;
    }

    // Function to safely mint a new NFT and set the token URI (linking to off-chain metadata)
    function safeMint(address to, string memory uri) public onlyOwner {
        require(_tokenIdCounter < maxSupply, "Max supply reached, no more NFTs can be minted");
        require(to != address(0), "address zero not allowed");
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);

        // Mark the token as existing
        _tokenExists[tokenId] = true;

        // Set the token URI for the newly minted token
        _setTokenURI(tokenId, uri);

        emit Minted(to, tokenId, uri);
    }

    // Internal function to set the token URI for a given tokenId
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }

    // Public function to get the token URI (metadata) of a specific tokenId
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Custom check to see if the token exists using the _tokenExists mapping
        require(_tokenExists[tokenId], "Token does not exist");
        return _tokenURIs[tokenId];
    }

    // Public function for the Event Contract to verify ownership
    function checkOwnership(address user, uint256 tokenId) public view returns (bool) {
        // Custom check to see if the token exists using _tokenExists mapping
        require(_tokenExists[tokenId], "Token does not exist");
        return ownerOf(tokenId) == user;
    }
}
