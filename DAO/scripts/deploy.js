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
        "0x2Bc63e7413AE6193c7D617Ef9835c99340cF4a85",
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
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