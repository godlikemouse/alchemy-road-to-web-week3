# ChainBattles Hardhat project

This project contains the code for Alchemy's Road To Web3 Week 3 challenge.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

## Mumbai Deploy

    npx hardhat run scripts/deploy.js --network mumbai

## Mumbai Verify

Capture the address from the above command and issue the following:

    npx hardhat verify --network mumbai 0xYourAddressFromAbove
