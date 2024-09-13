import { ethers } from "hardhat";

async function main() {
    const [owner, user1] = await ethers.getSigners();  // Fetch the signers

    // Add a check to ensure that user1 is correctly retrieved
    if (!user1) {
        throw new Error("user1 signer could not be retrieved");
    }

    // Contract addresses
    const mintingNFTAddress = "0x09637f772aaF7d457B7d5081a006A5ad762e8ea1";  // Replace with actual MintingNFT deployed address
    const eventRegistrationAddress = "0x35Cef369f738FbABab116cC375CBA16fd5D65b68";  // Replace with actual EventRegistration deployed address

    // Get contract factories and attach contracts using their addresses
    const mintingNFT = (await ethers.getContractAt("MintingNFT", mintingNFTAddress));
    const eventRegistration = (await ethers.getContractAt("EventRegistration", eventRegistrationAddress));

    // Mint an NFT for user1
    const mintTx = await mintingNFT.safeMint(user1.address, "https://ipfs.io/ipfs/QmV4WHmgRAnUwnp7HsbUfY6wryqLVv4r8dURwcV7agdhv6");  // Replace with actual IPFS URI
    await mintTx.wait();
    console.log(`Minted NFT for ${user1.address}`);

    // User1 registers for the event using the minted NFT
    const tokenId = 0;  // Assuming the first token minted has ID 0
    const registerTx = await eventRegistration.connect(user1).registerForEvent(tokenId);
    await registerTx.wait();
    console.log(`${user1.address} has successfully registered for the event.`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
