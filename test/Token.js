const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        // deploy Token
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy();
    });
    // TESTS
    it("Token has correct data at deployment", async function () {
        expect(await token.burnTax()).to.equal(0);
        expect(await token.contractAdmin()).to.equal(owner.address);
        expect(await token.decimals()).to.equal(18);
        expect(await token.devTax()).to.equal(0);
        expect(await token.devWallet()).to.equal("0x0000000000000000000000000000000000000000");
        expect(await token.downlineNFT()).to.equal("0x0000000000000000000000000000000000000000");
        expect(await token.liquidityTax()).to.equal(0);
        expect(await token.minted()).to.equal(0);
        expect(await token.name()).to.equal("Furio Token");
        expect(await token.paused()).to.equal(true);
        expect(await token.players()).to.equal(0);
        expect(await token.pool()).to.equal("0x0000000000000000000000000000000000000000");
        expect(await token.presaleNFT()).to.equal("0x0000000000000000000000000000000000000000");
        expect(await token.symbol()).to.equal("$FUR");
        expect(await token.taxRate()).to.equal(10);
        expect(await token.totalSupply()).to.equal(0);
        expect(await token.transactions()).to.equal(0);
        expect(await token.vault()).to.equal("0x0000000000000000000000000000000000000000");
        expect(await token.vaultTax()).to.equal(10);
    });
    // ADMIN
    it("Can set contract admin", async function () {
        await expect(token.setContractAdmin(addr1.address)).to.not.be.reverted;
        expect(await token.contractAdmin()).to.equal(addr1.address);
    });
    it("Cannot set contract admin by non admin account", async function () {
        await expect(token.connect(addr1).setContractAdmin(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can pause and unpause contract", async function () {
        expect(await token.paused()).to.equal(true);
        await expect(token.unpause()).to.not.be.reverted;
        expect(await token.paused()).to.equal(false);
        await expect(token.pause()).to.not.be.reverted;
        expect(await token.paused()).to.equal(true);
    });
    it("Can set dev wallet", async function () {
        await expect(token.setDevWallet(addr1.address)).to.not.be.reverted;
        expect(await token.devWallet()).to.equal(addr1.address);
    });
    it("Cannot set dev wallet by non admin account", async function () {
        await expect(token.connect(addr1).setDevWallet(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can set downline NFT", async function () {
        await expect(token.setDownlineNFT(addr1.address)).to.not.be.reverted;
        expect(await token.downlineNFT()).to.equal(addr1.address);
    });
    it("Cannot set downline NFT by non admin account", async function () {
        await expect(token.connect(addr1).setDownlineNFT(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can set pool", async function () {
        await expect(token.setPool(addr1.address)).to.not.be.reverted;
        expect(await token.pool()).to.equal(addr1.address);
    });
    it("Cannot set pool by non admin account", async function () {
        await expect(token.connect(addr1).setPool(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can set presale NFT", async function () {
        await expect(token.setPresaleNFT(addr1.address)).to.not.be.reverted;
        expect(await token.presaleNFT()).to.equal(addr1.address);
    });
    it("Cannot set presale NFT by non admin account", async function () {
        await expect(token.connect(addr1).setPresaleNFT(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can set vault", async function () {
        await expect(token.setVault(addr1.address)).to.not.be.reverted;
        expect(await token.vault()).to.equal(addr1.address);
    });
    it("Cannot set vault by non admin account", async function () {
        await expect(token.connect(addr1).setVault(addr2.address)).to.be.revertedWith("Unauthorized");
    });
    it("Can set tax rates", async function () {
        await expect(token.setVaultTax(0)).to.not.be.reverted;
        await expect(token.setBurnTax(10)).to.not.be.reverted;
        expect(await token.burnTax()).to.equal(10);
        expect(await token.taxRate()).to.equal(10);
        await expect(token.setLiquidityTax(10)).to.not.be.reverted;
        expect(await token.liquidityTax()).to.equal(10);
        expect(await token.taxRate()).to.equal(20);
        await expect(token.setVaultTax(10)).to.not.be.reverted;
        expect(await token.vaultTax()).to.equal(10);
        expect(await token.taxRate()).to.equal(30);
        await expect(token.setDevTax(10)).to.not.be.reverted;
        expect(await token.devTax()).to.equal(10);
        expect(await token.taxRate()).to.equal(40);
    });
    it("Cannot set tax rates by non admin account", async function () {
        await expect(token.connect(addr1).setBurnTax(10)).to.be.revertedWith("Unauthorized");
        await expect(token.connect(addr1).setLiquidityTax(10)).to.be.revertedWith("Unauthorized");
        await expect(token.connect(addr1).setVaultTax(10)).to.be.revertedWith("Unauthorized");
        await expect(token.connect(addr1).setDevTax(10)).to.be.revertedWith("Unauthorized");
    });
    // MINTING
    it("Downline NFT can mint tokens", async function () {
        await expect(token.setDownlineNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
    });
    it("Pool can mint tokens", async function () {
        await expect(token.setPool(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
    });
    it("Presale NFT can mint tokens", async function () {
        await expect(token.setPresaleNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
    });
    it("Vault can mint tokens", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
    });
    it("Cannot mint tokens by non trusted address", async function () {
        await expect(token.mint(owner.address, "10000000000000000")).to.be.revertedWith("Unauthorized");
    });
    // BURNING
    it("Downline NFT can burn tokens", async function () {
        await expect(token.setDownlineNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.burn(addr1.address, "5000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("5000000000000000");
    });
    it("Pool can burn tokens", async function () {
        await expect(token.setPool(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.burn(addr1.address, "5000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("5000000000000000");
    });
    it("Presale NFT can burn tokens", async function () {
        await expect(token.setPresaleNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.burn(addr1.address, "5000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("5000000000000000");
    });
    it("Vault can burn tokens", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.burn(addr1.address, "5000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("5000000000000000");
    });
    it("Cannot burn tokens by non trusted address", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.setVault(addr1.address)).to.not.be.reverted;
        await expect(token.burn(addr1.address, "5000000000000000")).to.be.revertedWith("Unauthorized");
        expect(await token.totalSupply()).to.equal("10000000000000000");
    });
    // PROTECTED TRANSFERS
    it("Downline NFT can transfer tokens", async function () {
        await expect(token.setDownlineNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
        await expect(token.protectedTransfer(addr1.address, addr2.address, "5000000000000000", 0)).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.balanceOf(addr2.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("10000000000000000");
    });
    it("Pool can transfer tokens", async function () {
        await expect(token.setPool(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
        await expect(token.protectedTransfer(addr1.address, addr2.address, "5000000000000000", 0)).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.balanceOf(addr2.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("10000000000000000");
    });
    it("Presale NFT can transfer tokens", async function () {
        await expect(token.setPresaleNFT(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
        await expect(token.protectedTransfer(addr1.address, addr2.address, "5000000000000000", 0)).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.balanceOf(addr2.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("10000000000000000");
    });
    it("Vault can transfer tokens", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
        await expect(token.protectedTransfer(addr1.address, addr2.address, "5000000000000000", 0)).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal("5000000000000000");
        expect(await token.balanceOf(addr2.address)).to.equal("5000000000000000");
        expect(await token.totalSupply()).to.equal("10000000000000000");
    });
    it("Cannot transfer tokens by non trusted address", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(owner.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).protectedTransfer(owner.address, addr1.address, "10000000000000000", 0)).to.be.revertedWith("Unauthorized");
        expect(await token.balanceOf(owner.address)).to.equal("10000000000000000");
    });
    // ERC20
    it("Can transfer owned tokens", async function () {
        await expect(token.unpause()).to.not.be.reverted;
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).transfer(addr2.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal(0);
        expect(await token.balanceOf(addr2.address)).to.not.equal(0);
    });
    it("Cannot transfer owned tokens when paused", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).transfer(addr2.address, "10000000000000000")).to.be.revertedWith("Contract is paused");
    });
    it("Can approve and spend", async function () {
        await expect(token.unpause()).to.not.be.reverted;
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).approve(addr2.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.allowance(addr1.address, addr2.address)).to.equal("10000000000000000");
        await expect(token.connect(addr2).transferFrom(addr1.address, addr2.address, "10000000000000000")).to.not.be.reverted;
        expect(await token.balanceOf(addr1.address)).to.equal(0);
        expect(await token.balanceOf(addr2.address)).to.not.equal(0);
    });
    it("Cannot overspend", async function () {
        await expect(token.unpause()).to.not.be.reverted;
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).approve(addr2.address, "5000000000000000")).to.not.be.reverted;
        expect(await token.allowance(addr1.address, addr2.address)).to.equal("5000000000000000");
        await expect(token.connect(addr2).transferFrom(addr1.address, addr2.address, "10000000000000000")).to.be.revertedWith("Insufficient allowance");
        expect(await token.balanceOf(addr1.address)).to.equal("10000000000000000");
        expect(await token.balanceOf(addr2.address)).to.equal(0);
    });
    it("Cannot approve when paused", async function () {
        await expect(token.setVault(owner.address)).to.not.be.reverted;
        await expect(token.mint(addr1.address, "10000000000000000")).to.not.be.reverted;
        await expect(token.connect(addr1).approve(addr2.address, "10000000000000000")).to.be.revertedWith("Contract is paused");
    });
});
