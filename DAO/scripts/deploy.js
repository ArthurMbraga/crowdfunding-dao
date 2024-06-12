const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function deployDAO() {
    const provider = new ethers.JsonRpcProvider();
    const signer = await provider.getSigner();

    const daoArtifact = JSON.parse(fs.readFileSync(path.join(__dirname, "../artifacts/contracts/DAO.sol/DAO.json"), "utf8"));
    const daoAbi = daoArtifact.abi;
    const daoBytecode = daoArtifact.bytecode;

    const daoFactory = new ethers.ContractFactory(daoAbi, daoBytecode, signer);

    const initialRecipients = [
        process.env.WALLET_ADDRESS1,
        process.env.WALLET_ADDRESS2,
        process.env.WALLET_ADDRESS3,
    ];
    const initialAmounts = [
        ethers.parseUnits("1000", 18),
        ethers.parseUnits("1000", 18),
        ethers.parseUnits("1000", 18)
    ];

    const daoContract = await daoFactory.deploy(initialRecipients, initialAmounts);
    await daoContract.waitForDeployment();

    console.log("DAO deployed to:", await daoContract.getAddress());
}

deployDAO().catch(console.error);