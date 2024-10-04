const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("EventManagementModule", (m) => {
  const eventManagement = m.contract(
    "EventManagement",
    ["0x6017c82c940d533de17293a760a97e4b8a4e5b90"],
    {}
  );

  return { eventManagement };
});

// deployed addres: 0x7fcB3B29ad0E890f0014406944aD039Ca4209e7C
