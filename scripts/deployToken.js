const { ethers } = require("hardhat");
const hre = require("hardhat");

async function deployToken() {
    const [deployer] = await hre.ethers.getSigners();
    // deploy Token
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    console.log("Token deployed to", token.address);
    return token.address;
}

deployToken()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
