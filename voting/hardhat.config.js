require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",

  defaultNetwork: "running",

  networks: {
    hardhat: {
      chainId: 1337
    },

    running: {
      url: "http://localhost:8545",
      chainId: 1337,
    }
  }
};

require('@openzeppelin/hardhat-upgrades');

