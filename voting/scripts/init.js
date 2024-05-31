const helpers = require("@nomicfoundation/hardhat-network-helpers");

async function init() {
  const address = "0x2Bc63e7413AE6193c7D617Ef9835c99340cF4a85";

  await helpers.setBalance(address, 1000 * 1e18);
}

init()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });