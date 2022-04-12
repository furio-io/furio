const { expect } = require("chai");
const { ethers } = require("hardhat");

const claimStart = "May 01 2022 19:59:30 GMT+0000";
const name = "Furio Presale NFT";
const presaleOneMax = 1;
const presaleOnePrice = "250000000";
const presaleOneStart = "Apr 19 2022 19:59:30 GMT+0000";
const presaleOneSupply = 300;
const presaleOneValue = "500000000000000000000";
const presaleThreeMax = 10;
const presaleThreePrice = "175000000";
const presaleThreeStart = "Apr 27 2022 19:59:30 GMT+0000";
const presaleThreeSupply = 1250;
const presaleThreeValue = "100000000000000000000";
const presaleTwoMax = 10;
const presaleTwoPrice = "150000000";
const presaleTwoStart = "Apr 23 2022 19:59:30 GMT+0000";
const presaleTwoSupply = 1250;
const presaleTwoValue = "100000000000000000000";
const symbol = "$FURPRESALE";
const ownableRevert = "Ownable: caller is not the owner";

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
        // deploy treasury
        Treasury = await ethers.getContractFactory("Treasury");
        treasury = await Treasury.deploy();
        // deploy PresaleNFT
        PresaleNft = await ethers.getContractFactory("PresaleNft");
        presalenft = await PresaleNft.deploy();
        await presalenft.setPaymentToken(usdc.address);
        await presalenft.setFurioToken(token.address);
        await presalenft.setTreasury(treasury.address);
    });
    // TESTS
    it("Deployment has correct data", async function () {
        expect(await presalenft.claimStart()).to.equal(Date.parse(claimStart) / 1000);
        expect(await presalenft.furioToken()).to.equal(token.address);
        expect(await presalenft.name()).to.equal(name);
        expect(await presalenft.owner()).to.equal(owner.address);
        expect(await presalenft.paymentToken()).to.equal(usdc.address);
        expect(await presalenft.presaleOneMax()).to.equal(presaleOneMax);
        expect(await presalenft.presaleOnePrice()).to.equal(presaleOnePrice);
        expect(await presalenft.presaleOneStart()).to.equal(Date.parse(presaleOneStart) / 1000);
        expect(await presalenft.presaleOneSupply()).to.equal(presaleOneSupply);
        expect(await presalenft.presaleOneValue()).to.equal(presaleOneValue);
        expect(await presalenft.presaleThreeMax()).to.equal(presaleThreeMax);
        expect(await presalenft.presaleThreePrice()).to.equal(presaleThreePrice);
        expect(await presalenft.presaleThreeStart()).to.equal(Date.parse(presaleThreeStart) / 1000);
        expect(await presalenft.presaleThreeSupply()).to.equal(presaleThreeSupply);
        expect(await presalenft.presaleThreeValue()).to.equal(presaleThreeValue);
        expect(await presalenft.presaleTwoMax()).to.equal(presaleTwoMax);
        expect(await presalenft.presaleTwoPrice()).to.equal(presaleTwoPrice);
        expect(await presalenft.presaleTwoStart()).to.equal(Date.parse(presaleTwoStart) / 1000);
        expect(await presalenft.presaleTwoSupply()).to.equal(presaleTwoSupply);
        expect(await presalenft.presaleTwoValue()).to.equal(presaleTwoValue);
        expect(await presalenft.symbol()).to.equal(symbol);
        expect(await presalenft.treasury()).to.equal(treasury.address);
    });
    it("Can renounce ownership", async function () {
        await expect(presalenft.renounceOwnership()).to.not.be.reverted;
        expect(await presalenft.owner()).to.equal("0x0000000000000000000000000000000000000000");
    });
    it("Non admin cannot renounce ownership", async function () {
        await expect(presalenft.connect(addr1).renounceOwnership()).to.be.revertedWith(ownableRevert);
        expect(await presalenft.owner()).to.equal(owner.address);
    });
    it("Can set furio token", async function () {
        await expect(presalenft.setFurioToken(addr1.address)).to.not.be.reverted;
        expect(await presalenft.furioToken()).to.equal(addr1.address);
    });
    it("Non admin cannot set furio token", async function () {
        await expect(presalenft.connect(addr1).setFurioToken(addr1.address)).to.be.revertedWith(ownableRevert)
        expect(await presalenft.furioToken()).to.equal(token.address);
    });
    it("Can set payment token", async function () {
        await expect(presalenft.setPaymentToken(addr1.address)).to.not.be.reverted;
        expect(await presalenft.paymentToken()).to.equal(addr1.address);
    });
    it("Non admin cannot set payment token", async function () {
        await expect(presalenft.connect(addr1).setPaymentToken(addr1.address)).to.be.revertedWith(ownableRevert)
        expect(await presalenft.paymentToken()).to.equal(usdc.address);
    });
    it("Can set presale one max", async function () {
        await expect(presalenft.setPresaleOneMax(5)).to.not.be.reverted;
        expect(await presalenft.presaleOneMax()).to.equal(5);
    });
    it("Non admin cannot set payment token", async function () {
        await expect(presalenft.connect(addr1).setPresaleOneMax(5)).to.be.revertedWith(ownableRevert)
        expect(await presalenft.presaleOneMax()).to.equal(1);
    });
});

async function getBlockTimestamp () {
    return (await hre.ethers.provider.getBlock("latest")).timestamp;
}
