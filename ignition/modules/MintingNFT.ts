const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("MintingNFTModule", (m) => {
  const mintingNFT = m.contract("MintingNFT", ["Akinola", "Ak", 10000], {});

  return { mintingNFT };
});

// deloyment address: 0x6017C82c940D533dE17293A760a97E4b8a4E5B90
