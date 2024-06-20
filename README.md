# Hardhat Project

This project is a Hardhat-based Ethereum project with a set of smart contracts and scripts for deployment and interaction.

## Prerequisites

- Node.js and npm installed on your machine
- An Ethereum wallet with some test Ether (for deployment and transaction fees)

## Setup

1. Install the project dependencies:

```sh
npm install
```

2. Create a `.env` file in the project root and add the following environment variables:

```sh
DEPLOYER_PRIVATE_KEY=YourWalletPrivateKey
WALLET_ADDRESS1=Address1
WALLET_ADDRESS2=Address2
WALLET_ADDRESS3=Address3
...
```

3. Compile the smart contracts:

```sh
npm run compile
```

## Deployment

To deploy the smart contracts, run:

```sh
npm run deploy
```
and choose the DAO option.

## Scripts

To run a script, use the following command:

```sh
npx hardhat run scripts/<script-name>.js
```

There are two scripts available:

1. `deploy.js`: Deploys the DAO smart contract to the network
2. `create-campaign.js`: Creates a new campaign
