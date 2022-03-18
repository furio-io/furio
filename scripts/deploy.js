const hre = require("hardhat");
const USDC_ADDRESS = '0xeb8f08a975Ab53E34D8a0330E0D34de942C95926';

async function main() {
    // DEPLOY TOKEN
    const Token = await hre.ethers.getContractFactory("Token");
    const token = await Token.deploy();
    console.log("Token deployed to:", token.address);
    const NFT = await hre.ethers.getContractFactory("NFT");
    const nft = await NFT.deploy(token.address);
    console.log("NFT deployed to:", nft.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
