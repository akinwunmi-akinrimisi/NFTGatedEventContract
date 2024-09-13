import { ethers } from "hardhat";

async function mintNFT() {
  // Get the signers from Hardhat (the deployer and recipient)
  const [owner, recipient] = await ethers.getSigners();

  // Attach to the already deployed contract
  const EventNFT = await ethers.getContractFactory("EventNFT");
  const contract = EventNFT.attach("<Deployed_Contract_Address>"); // Replace with actual deployed contract address

  // IPFS URI for the metadata JSON file
  const metadataURI = "https://ipfs.io/ipfs/QmV4WHmgRAnUwnp7HsbUfY6wryqLVv4r8dURwcV7agdhv6"; // Replace with your actual IPFS URI

  // Call the safeMint function to mint an NFT
  const tx = await contract.safeMint(recipient.address, metadataURI);

  // Wait for the transaction to be mined/confirmed
  await tx.wait();

  console.log(`NFT minted successfully to ${recipient.address}`);
}

mintNFT().catch((error) => {
  console.error("Error minting NFT:", error);
  process.exit(1);
});

