const { ethers } = require("hardhat");
const hre = require("hardhat");

const _teamWallets = [
    "0x9dd628ABa91a0af7F00cd9580D7f1E99CC739122",
    "0x4e53d5337F6Da44abc8aC55019FA56a1A0BD91e5",
    "0x853Cc756E094D68D0D5F2b9209839FfdCa2EF665",
    "0x5835E9EA7E83e2ECd025dCa4Fb507ECAD8124687",
    "0x8B26AD31E0Efc5ec563236FafdA0C9A97358b8D8",
    "0x8dC1e1deB76565e2CdCF18000cf0E6d105E3E751",
    "0xB4384c628f75c63A7166894A7D9671d932097dE7",
    "0xfD44607caC6B80dA7F0932d0F20C3fc02dd25D70",
    "0xA5877F66ECec45d855B3DB394d0fb0655d56D0E9",
    "0xA796e7cAd2f7A4723644B7Ab99D0c85d9BCe4CC4",
    "0xA8fd2eDb31E7A31E88fD624889ef0F247269350E",
    "0x9E8bFc4c9F527907871fb45346D78aF793506a3c",
    "0x60cBffE1E330014B786B7B6eDe8359051148Dde6",
    "0xF40775b920C4A2B6106D07217fdd5b71F88ADd14"
];

const _familyWallets = [
    "0xb3eDA828585C2A49E0FF1DEc2DB2D270Ca162dBf"
];

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    // deploy Token
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
