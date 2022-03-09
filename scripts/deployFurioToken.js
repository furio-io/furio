const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    const FurioToken = await hre.ethers.getContractFactory("FurioToken");
    const furiotoken = await FurioToken.deploy();
    await furiotoken.deployed();
    console.log("Transaction created:", furiotoken.deployTransaction.hash);
    console.log("Contract deployed to:", furiotoken.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
