const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Treasury", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();
        // deploy USDC
        USDC = await ethers.getContractFactory("Treasury");
        usdc = await USDC.deploy();
        // deploy Token
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy();
        // deploy Treasury
        Treasury = await ethers.getContractFactory("Treasury");
        treasury = await Treasury.deploy();
    });
    // TESTS
    it("Ownership", async function () {
        // owner should be owner
        expect(await treasury.isOwner(owner.address)).to.equal(true);
        // addr1 should not be owner
        expect(await treasury.isOwner(addr1.address)).to.equal(false);
        // owner should be able to add addr1 as an owner
        await expect(treasury.addOwner(addr1.address)).to.not.be.reverted;
        expect(await treasury.isOwner(addr1.address)).to.equal(true);
        // addr2 should NOT be able to add an owner
        await expect(treasury.connect(addr2).addOwner(addr2.address)).to.be.revertedWith("Unauthorized");
        // addr1 SHOULD be able to start a vote to add an owner
        await expect(treasury.connect(addr1).addOwner(addr2.address)).to.not.be.reverted;
        // vote hasn't reached 75% of owners yet so addr2 should not be an owner
        expect(await treasury.isOwner(addr2.address)).to.equal(false);
        // owner should be able to also vote to add addr2
        await expect(treasury.addOwner(addr2.address)).to.not.be.reverted;
        // addr2 should now be an owner
        expect(await treasury.isOwner(addr2.address)).to.equal(true);
        // owner should be able to vote to add addr3
        await expect(treasury.addOwner(addr3.address)).to.not.be.reverted;
        // addr3 should not YET be an owner
        expect(await treasury.isOwner(addr3.address)).to.equal(false);
        // addr1 should be able to vote to add addr3
        await expect(treasury.connect(addr1).addOwner(addr3.address)).to.not.be.reverted;
        // addr3 should STILL not yet be an owner
        expect(await treasury.isOwner(addr3.address)).to.equal(false);
        // addr3 should NOT be able to vote to add himself
        await expect(treasury.connect(addr3).addOwner(addr3.address)).to.be.revertedWith("Unauthorized");
        // addr1 cannot vote again on adding addr3
        await expect(treasury.connect(addr1).addOwner(addr3.address)).to.be.revertedWith("Already voted");
        expect(await treasury.isOwner(addr3.address)).to.equal(false);
        // FINALLY, addr2 can also vote for addr3 making him an owner
        await expect(treasury.connect(addr2).addOwner(addr3.address)).to.not.be.reverted;
        expect(await treasury.isOwner(addr3.address)).to.equal(true);
        // owner can vote to remove addr1
        await expect(treasury.removeOwner(addr1.address)).to.not.be.reverted;
        // addr1 should still be an owner until 75% consensus is reached
        expect(await treasury.isOwner(addr1.address)).to.equal(true);
        // addr2 can vote to remove addr1
        await expect(treasury.connect(addr2).removeOwner(addr1.address)).to.not.be.reverted;
        // addr1 should still be an owner until 75% consensus is reached
        expect(await treasury.isOwner(addr1.address)).to.equal(true);
        // addr3 can vote to remove addr1
        await expect(treasury.connect(addr3).removeOwner(addr1.address)).to.not.be.reverted;
        // addr1 should no longer be an owner
        expect(await treasury.isOwner(addr1.address)).to.equal(false);
    });
});
