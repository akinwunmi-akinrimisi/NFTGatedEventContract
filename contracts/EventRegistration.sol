// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MintNFT.sol";  // Import the Minting Contract

contract EventRegistration {
    MintingNFT public mintingNFTContract;  // Reference to the Minting Contract

    // List of registered users for the event
    mapping(address => bool) public registeredUsers;

    // Event to log registrations
    event Registered(address indexed user, uint256 tokenId);

    // Constructor to set the Minting NFT contract address
    constructor(address _mintingNFTContract) {
        mintingNFTContract = MintingNFT(_mintingNFTContract);
    }

    // Function for users to register for an event using their NFT
    function registerForEvent(uint256 tokenId) public {
        require(!registeredUsers[msg.sender], "You are already registered.");
        require(mintingNFTContract.checkOwnership(msg.sender, tokenId), "You do not own this NFT.");

        // Mark the user as registered
        registeredUsers[msg.sender] = true;

        // Emit registration event
        emit Registered(msg.sender, tokenId);
    }

    // Function to check if a user is registered
    function isRegistered(address user) public view returns (bool) {
        return registeredUsers[user];
    }
}

// MintingNFT deployed to: 0x09637f772aaF7d457B7d5081a006A5ad762e8ea1
// EventRegistration deployed to: 0x35Cef369f738FbABab116cC375CBA16fd5D65b68
// Minted NFT for 0x8B286eF43CcB1B3842f925e3BEF8B712BE408035