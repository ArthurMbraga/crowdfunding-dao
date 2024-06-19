require("dotenv").config();
const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    const provider = new ethers.JsonRpcProvider();
    const signer = await provider.getSigner();

    console.log("Creating campaign with the account:", await signer.getAddress());

    const daoAddress = process.env.DAO_CONTRACT_ADDRESS;
    const daoArtifact = JSON.parse(fs.readFileSync(path.join(__dirname, "../artifacts/contracts/DAO.sol/DAO.json"), "utf8"));
    const daoAbi = daoArtifact.abi;

    const daoContract = new ethers.Contract(daoAddress, daoAbi, signer);

    const tx = await daoContract.createCampaign("Teste", ethers.parseUnits("100", 18), 150);
    await tx.wait();

    console.log("Campaign created successfully");
    const campaignCreatedFilter = daoContract.filters.CampaignCreated();
    const campaignCreatedEvents = await daoContract.queryFilter(campaignCreatedFilter);
    console.log("CampaignCreated Events:");
    campaignCreatedEvents.forEach(event => {
        console.log(`- CampaignAddress: ${event.args.campaignAddress}, Creator: ${event.args.creator}, Goal: ${event.args.goal.toString()}, Deadline: ${event.args.deadline.toString()}`);
    });

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
