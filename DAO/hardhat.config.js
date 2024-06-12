require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24", // Ajuste para uma versão suportada
  networks: {
    hardhat: {
      chainId: 1337,
    },
  },
};