# Alchemy's Road to Web3 Week 3

This repository covers the modified code following Alchemy's Road to Web3 Week 3.

## Development Environment Setup

Ensure you have npm installed. Create a `.env` file under the `/ChainBattles` directory which includes the following keys:

    TESTNET_RPC=
    PRIVATE_KEY=
    POLYGONSCAN_API_KEY=

## Organization

`/ChainBattles` The hardhat contract repo including test and deployment scripts.

## Hardhat

Ensure you're under the `/ChainBattles` directory.

### Install Dependencies

    npm i

### Testing

To run the general test suit execute the following:

    npx hardhat test

### Deployment

    npx hardhat run scripts/deploy.js

## NFT Contract Non-Standard Interface

This NFT is a living blockchain NFT which generates an image based on changing data. To update the visual data invoke the:

    train( tokenId )
