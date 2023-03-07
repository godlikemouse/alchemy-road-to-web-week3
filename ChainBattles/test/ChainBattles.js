const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const hre = require("hardhat");

describe("ChainBattles", function () {
    let owner;
    let mintedNFT;

    before(async () => {
        [owner] = await hre.ethers.getSigners();
    });

    it("Contract deployed correctly", async () => {
        const ChainBattles = await ethers.getContractFactory("ChainBattles");
        chainBattles = await ChainBattles.deploy();

        expect(chainBattles.address != "");
    });

    it("Mint an NFT", async () => {
        const tx = await chainBattles.mint();
        const ChainBattles = await ethers.getContractFactory("ChainBattles");
        mintedNFT = await ChainBattles.attach(tx.to);
        expect(mintedNFT);
    });

    it("Train the NFT with token id 1", async () => {
        const tx = await mintedNFT.train(1);
        expect(tx);
    });

    it("Train the NFT with token id 2 (fail)", async () => {
        let error = false;
        try {
            const tx = await mintedNFT.train(2);
        } catch (ex) {
            error = true;
        }
        expect(error);
    });

    it("Call generateCharacter with token id 1", async () => {
        const c = await mintedNFT.generateCharacter(1);
        expect(c != "");
    });

    it("Call getStats with token id 1", async () => {
        const [hp, strength, speed, level] = await mintedNFT.getStats(1);
        expect(level.toNumber() == 2);
    });

    it("Call getTokenURI with token id 1", async () => {
        const uri = await chainBattles.getTokenURI(1);
        expect(uri.includes("data:application/json;base64"));
    });
});
