const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FurioNFT", function () {
    // RUN THIS BEFORE EACH TEST
    beforeEach(async function () {
        FurioNFT = await ethers.getContractFactory("FurioNFT");
        furionft = await FurioNFT.deploy();
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    });
    // TESTS
    describe("Deployment", function () {
        it("Has an address", async function() {
            expect(furionft.address).to.not.equal(0);
        });
    });
});
