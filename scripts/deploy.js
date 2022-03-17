const hre = require("hardhat");
const USDC_ADDRESS = '0xeb8f08a975Ab53E34D8a0330E0D34de942C95926';

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    const BuddySystem = await hre.ethers.getContractFactory("BuddySystem");
    const buddysystem = await BuddySystem.deploy();
    await buddysystem.deployed();
    console.log("BuddySystem deployed to:", buddysystem.address);
    const FurioToken = await hre.ethers.getContractFactory("FurioToken");
    const furiotoken = await FurioToken.deploy(1000000);
    await furiotoken.deployed();
    console.log("Furio token deployed to:", furiotoken.address);
    const Fountain = await hre.ethers.getContractFactory("Fountain");
    const fountain = await Fountain.deploy(furiotoken.address);
    await fountain.deployed();
    console.log("Fountain deployed to:", fountain.address);
    const Reservoir = await hre.ethers.getContractFactory("Reservoir");
    const reservoir = await Reservoir.deploy(furiotoken.address, USDC_ADDRESS);
    await reservoir.deployed();
    console.log("Reservoir deployed to:", reservoir.address);
    const TokenMint = await hre.ethers.getContractFactory("TokenMint");
    const tokenmint = await TokenMint.deploy(furiotoken.address);
    await tokenmint.deployed();
    console.log("TokenMint deployed to:", tokenmint.address);
    const Vault = await hre.ethers.getContractFactory("Vault");
    const vault = await Vault.deploy(furiotoken.address);
    await vault.deployed();
    console.log("Vault deployed to:", vault.address);
    const Faucet = await hre.ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy(tokenmint.address, USDC_ADDRESS, furiotoken.address, vault.address);
    await faucet.deployed();
    console.log("Faucet deployed to:", faucet.address);
    const FurioNFT = await hre.ethers.getContractFactory("FurioNFT");
    const furionft = await FurioNFT.deploy();
    await furionft.deployed();
    console.log("Furio NFT deployed to:", furionft.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
