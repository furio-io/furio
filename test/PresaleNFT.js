const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Presale NFT", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        // deploy USDC
        USDC = await ethers.getContractFactory("MockUSDC");
        usdc = await USDC.deploy();
        // deploy Token
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy();
        // deploy DownlineNFT
        DownlineNFT = await ethers.getContractFactory("DownlineNFT");
        downlinenft = await DownlineNFT.deploy();
        // deploy PresaleNFT
        PresaleNFT = await ethers.getContractFactory("PresaleNFT");
        presalenft = await PresaleNFT.deploy();
        await presalenft.setPaymentToken(usdc.address);
        await presalenft.setFurToken(token.address);
        await presalenft.setDownlineNft(downlinenft.address);
    });
    // TESTS
    it("Presale NFT has correct data at deployment", async function () {
    });
});
