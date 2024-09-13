// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MintNFT.sol";  // Import the MintingNFT contract to check NFT ownership
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventManagement {
    MintingNFT public mintingNFTContract;

    uint256 public eventCounter;  // Counter to track event IDs

    // Event structure to store event details
    struct Event {
        uint256 eventId;
        address creator;
        string name;
        string description;
        uint256 maxParticipants;
        uint256 registeredCount;
        bool isRegistrationOpen;
        mapping(address => bool) registeredUsers;  // Track registered users
    }

    // Mapping from event ID to Event structure
    mapping(uint256 => Event) public events;

    // Event emitted when a new event is created
    event EventCreated(uint256 eventId, address indexed creator, string name);

    // Event emitted when a user registers for an event
    event Registered(uint256 eventId, address indexed user);

    // Modifier to ensure only the event creator can manage the event
    modifier onlyEventCreator(uint256 eventId) {
        require(events[eventId].creator == msg.sender, "Only the event creator can manage this event.");
        _;
    }

    constructor(address _mintingNFTContract) {
        mintingNFTContract = MintingNFT(_mintingNFTContract);
    }

    // Function to create a new event
    function createEvent(string memory name, string memory description, uint256 maxParticipants) public {
        eventCounter++;
        Event storage newEvent = events[eventCounter];
        newEvent.eventId = eventCounter;
        newEvent.creator = msg.sender;
        newEvent.name = name;
        newEvent.description = description;
        newEvent.maxParticipants = maxParticipants;
        newEvent.isRegistrationOpen = true;  // Event starts with registration open

        emit EventCreated(eventCounter, msg.sender, name);
    }

    // Function to register for an event using an NFT
    function registerForEvent(uint256 eventId, uint256 tokenId) public {
        Event storage myEvent = events[eventId];

        // Ensure registration is open
        require(myEvent.isRegistrationOpen, "Event registration is closed.");
        // Ensure the event has not reached the max participants
        require(myEvent.registeredCount < myEvent.maxParticipants, "Event is full.");
        // Ensure the user is not already registered
        require(!myEvent.registeredUsers[msg.sender], "You have already registered for this event.");
        // Ensure the user owns the NFT
        require(mintingNFTContract.checkOwnership(msg.sender, tokenId), "You do not own the required NFT.");

        // Register the user for the event
        myEvent.registeredUsers[msg.sender] = true;
        myEvent.registeredCount++;

        emit Registered(eventId, msg.sender);
    }

    // Function to close registration for an event
    function closeRegistration(uint256 eventId) public onlyEventCreator(eventId) {
        events[eventId].isRegistrationOpen = false;
    }

    // Function to update event details (name and description)
    function updateEventDetails(uint256 eventId, string memory newName, string memory newDescription) public onlyEventCreator(eventId) {
        events[eventId].name = newName;
        events[eventId].description = newDescription;
    }

    // Function to check if a user is registered for an event
    function isUserRegistered(uint256 eventId, address user) public view returns (bool) {
        return events[eventId].registeredUsers[user];
    }

    // Function to view the event details
    function getEventDetails(uint256 eventId) public view returns (string memory name, string memory description, uint256 maxParticipants, uint256 registeredCount, bool isRegistrationOpen) {
        Event storage myEvent = events[eventId];
        return (myEvent.name, myEvent.description, myEvent.maxParticipants, myEvent.registeredCount, myEvent.isRegistrationOpen);
    }
}


// MintingNFT deployed to: 0x09637f772aaF7d457B7d5081a006A5ad762e8ea1
// EventRegistration deployed to: 0x35Cef369f738FbABab116cC375CBA16fd5D65b68
// Minted NFT for 0x8B286eF43CcB1B3842f925e3BEF8B712BE408035