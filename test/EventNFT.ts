import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

async function deployEventNFTFixture() {
  // Get signers (accounts) from Hardhat
  const [owner, otherAccount, anotherAccount] = await hre.ethers.getSigners();

  // Compile and deploy the EventNFT contract
  const EventNFT = await hre.ethers.getContractFactory("EventNFT");
  const eventNFT = await EventNFT.deploy("EventNFT", "ENFT", 1000); // Deploy with name, symbol, and maxSupply

  // Return the contract instance and accounts for testing
  return { eventNFT, owner, otherAccount, anotherAccount };
}
