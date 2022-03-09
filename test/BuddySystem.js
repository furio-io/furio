const { expect } = require("chai");
const { Contract } = require("ethers");
const { ethers } = require("hardhat");

describe("BuddySystem", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        BuddySystem = await ethers.getContractFactory("BuddySystem");
        buddysystem = await BuddySystem.deploy();
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    });
    // TESTS
    describe("Functions", function () {
        it("Can update buddy", async function() {
            await expect(buddysystem.updateBuddy(addr1.address)).to.emit(buddysystem, "onUpdateBuddy").withArgs(owner.address, addr1.address);
            expect(await buddysystem.buddyOf(owner.address)).to.equal(addr1.address);
            expect(await buddysystem.myBuddy()).to.equal(addr1.address);
            await expect(buddysystem.updateBuddy(addr2.address)).to.emit(buddysystem, "onUpdateBuddy").withArgs(owner.address, addr2.address);
            expect(await buddysystem.buddyOf(owner.address)).to.equal(addr2.address);
            expect(await buddysystem.myBuddy()).to.equal(addr2.address);
        });
    });
});
