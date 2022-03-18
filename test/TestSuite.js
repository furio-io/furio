const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FullTest", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy();
        NFT = await ethers.getContractFactory("NFT");
        nft = await NFT.deploy(token.address);
    });
    // TESTS
    describe("Token Deployment", function () {
        it("Token has correct data at deployment", async function () {
            expect(await token.DEFAULT_ADMIN_ROLE()).to.equal('0x0000000000000000000000000000000000000000000000000000000000000000');
            expect(await token.MINTER_ROLE()).to.equal('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6');
            expect(await token.decimals()).to.equal(18);
            expect(await token.getRoleAdmin('0x0000000000000000000000000000000000000000000000000000000000000000')).to.equal('0x0000000000000000000000000000000000000000000000000000000000000000');
            expect(await token.getRoleAdmin('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6')).to.equal('0x0000000000000000000000000000000000000000000000000000000000000000');
            expect(await token.hasRole('0x0000000000000000000000000000000000000000000000000000000000000000', owner.address)).to.equal(true);
            expect(await token.hasRole('0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6', owner.address)).to.equal(true);
            expect(await token.mintedSupply()).to.equal(0);
            expect(await token.mintingFinished()).to.equal(false);
            expect(await token.name()).to.equal('Furio Token');
            expect(await token.players()).to.equal(0);
            expect(await token.symbol()).to.equal('$FUR');
            expect(await token.taxRate()).to.equal(10);
            expect(await token.totalSupply()).to.equal(0);
        });
    });
    describe("Token Admin Functions", function () {
        it("Owner can mint token", async function () {
            await expect(token.mint(owner.address, '100000000000000000')).to.not.be.reverted;
            expect(await token.balanceOf(owner.address)).to.equal('100000000000000000');
            expect(await token.mintedSupply()).to.equal('100000000000000000');
            expect(await token.totalSupply()).to.equal('100000000000000000');
        });
        it("Non owner cannot mint token", async function () {
            await expect(token.connect(addr1).mint(addr1.address, '100000000000000000')).to.be.reverted;
            expect(await token.balanceOf(addr1.address)).to.equal(0);
            expect(await token.mintedSupply()).to.equal(0);
            expect(await token.totalSupply()).to.equal(0);
        });
    });
    describe("Token User Functions", function () {
        it("Can approve, transfer, and transferFrom $FUR", async function () {
            // Mint 10 $FUR to owner
            await expect(token.mint(owner.address, '100000000000000000')).to.not.be.reverted;
            expect(await token.balanceOf(owner.address)).to.equal('100000000000000000');
            expect(await token.totalTransactions()).to.equal(1);
            expect(await token.players()).to.equal(1);
            // Transfer 1 $FUR to addr1
            await expect(token.approve(owner.address, '10000000000000000')).to.not.be.reverted;
            expect(await token.allowance(owner.address, owner.address)).to.equal('10000000000000000');
            await expect(token.transfer(addr1.address, '10000000000000000')).to.not.be.reverted;
            expect(await token.totalTransactions()).to.equal(2);
            expect(await token.players()).to.equal(2);
            // Balance should be 1 - 10%
            expect(await token.balanceOf(addr1.address)).to.equal('9000000000000000');
            // Owner can approve addr1 to spend tokens
            await expect(token.approve(addr1.address, '10000000000000000')).to.not.be.reverted;
            expect(await token.allowance(owner.address, addr1.address)).to.equal('10000000000000000');
            await expect(token.connect(addr1).transferFrom(owner.address, addr1.address, '10000000000000000')).to.not.be.reverted;
            expect(await token.totalTransactions()).to.equal(3);
            expect(await token.players()).to.equal(2);
            // Balance should have increased by .9 $FUR
            expect(await token.balanceOf(addr1.address)).to.equal('18000000000000000');
        });
    });
    describe("NFT Deployment", function () {
        it("NFT has correct data at deployment", async function () {
            expect(await nft.maxSupply()).to.equal(0);
            expect(await nft.name()).to.equal('Furio NFT');
            expect(await nft.owner()).to.equal(owner.address);
            expect(await nft.paymentToken()).to.equal(token.address);
            expect(await nft.price()).to.equal('50000000000000000');
            expect(await nft.symbol()).to.equal('$FURNFT');
            expect(await nft.taxRate()).to.equal(10);
            expect(await nft.totalSupply()).to.equal(0);
        });
    });
    describe("NFT Admin Functions", function () {
        it("Owner can create NFT generation", async function () {
            await expect(nft.createGeneration(10000, 'https://furio.io/')).to.not.be.reverted;
            expect(await nft.maxSupply()).to.equal(10000);
        });
        it("Non owner cannot create NFT generation", async function () {
            await expect(nft.connect(addr1).createGeneration(10000, 'https://furio.io/')).to.be.reverted;
            expect(await nft.maxSupply()).to.equal(0);
        });
    });
    describe("NFT User Functions", function () {
        it("Can buy and sell NFTs with $FUR", async function () {
            await expect(nft.createGeneration(10000, 'https://furio.io/')).to.not.be.reverted;
            await expect(token.mint(owner.address, '50000000000000000')).to.not.be.reverted;
            await expect(token.approve(nft.address, '50000000000000000')).to.not.be.reverted;
            await expect(nft.buy(1)).to.not.be.reverted;
            expect(await token.balanceOf(nft.address)).to.equal('45000000000000000');
            expect(await nft.balanceOf(owner.address)).to.equal(1);
            await expect(nft.sell(1)).to.not.be.reverted;
            expect(await token.balanceOf(owner.address)).to.equal('40500000000000000');
            expect(await nft.balanceOf(owner.address)).to.equal(0);
        });
    });
});
