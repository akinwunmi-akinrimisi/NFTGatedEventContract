import { ethers } from "hardhat";

async function main() {
    // Deploy the MintingNFT contract
    const MintingNFT = await ethers.getContractFactory("MintingNFT");
    const mintingNFT = await MintingNFT.deploy("EventNFT", "ENFT", 1000); // Deploy the contract
    await mintingNFT.deploymentTransaction(); // Wait for the contract deployment to be mined
    console.log("MintingNFT deployed to:", mintingNFT.target); // Use `target` to access the contract address

    // Deploy the EventRegistration contract with the address of MintingNFT
    const EventRegistration = await ethers.getContractFactory("EventRegistration");
    const eventRegistration = await EventRegistration.deploy(mintingNFT.target); // Pass the correct contract address
    await eventRegistration.deploymentTransaction(); // Wait for the contract deployment to be mined
    console.log("EventRegistration deployed to:", eventRegistration.target); // Use `target` to access the contract address
}

// Execute the main function
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
