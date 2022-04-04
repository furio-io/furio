const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    // deploy USDC
    USDC = await ethers.getContractFactory("MockUSDC");
    usdc = await USDC.deploy();
    console.log("USDC deployed to", usdc.address);
    await usdc.mint(deployer.address, "250000000000000000000");
    // deploy presale
    PresaleNFT = await ethers.getContractFactory("PresaleNFT");
    presalenft = await PresaleNFT.deploy();
    console.log("Presale NFT deployed to", presalenft.address);
    await presalenft.setPaymentToken(usdc.address);
    await presalenft.setDevWallet(deployer.address);
    await presalenft.unpause();
    // deploy token
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    console.log("Token deployed to", token.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
