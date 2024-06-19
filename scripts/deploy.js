require("dotenv").config();
const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");

async function deployDAO() {
    const provider = new ethers.JsonRpcProvider();
    const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY;
    if (!deployerPrivateKey) {
        throw new Error("Deployer private key is not defined in .env file");
    }

    const deployer = new ethers.Wallet(deployerPrivateKey, provider);

    console.log("Deploying contracts with the account:", deployer.getAddress());
    console.log("Account balance:", (await provider.getBalance(deployer.getAddress())).toString());

    const daoArtifact = JSON.parse(fs.readFileSync(path.join(__dirname, "../artifacts/contracts/DAO.sol/DAO.json"), "utf8"));
    const daoAbi = daoArtifact.abi;
    const daoBytecode = daoArtifact.bytecode;

    const daoFactory = new ethers.ContractFactory(daoAbi, daoBytecode, deployer);

    const initialRecipients = [];
    for (let i = 1; i <= 3; i++) {
        const address = process.env[`WALLET_ADDRESS${i}`];
        if (!address) {
            throw new Error(`WALLET_ADDRESS${i} is not defined in .env file`);
        }
        initialRecipients.push(address);
    }

    console.log("Initial recipients:", initialRecipients);

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