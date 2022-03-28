const { ethers } = require("hardhat");
const hre = require("hardhat");

const _teamWallets = [
    "0x9dd628ABa91a0af7F00cd9580D7f1E99CC739122",
    "0x4e53d5337F6Da44abc8aC55019FA56a1A0BD91e5",
    "0x853Cc756E094D68D0D5F2b9209839FfdCa2EF665",
    "0x5835E9EA7E83e2ECd025dCa4Fb507ECAD8124687",
    "0x8B26AD31E0Efc5ec563236FafdA0C9A97358b8D8",
    "0xBF1EC1C2d2C7578ec31dDA3750c11D8363a2e58d",
    "0x6d0a454bB6732E2bC7AFD49AB08E5FE9eB94739e"
];

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    // deploy MockUSDC
    MockUSDC = await ethers.getContractFactory("MockUSDC");
    mockusdc = await MockUSDC.deploy();
    await mockusdc.mint(deployer.address, '10000000000000000000');
    console.log("USDC deployed to:", mockusdc.address);
    // deploy Admin
    Admin = await ethers.getContractFactory("Admin");
    admin = await Admin.deploy();
    await admin.setPaymentToken(mockusdc.address);
    for (i = 0; i < _teamWallets.length; i ++) {
        await admin.addTeamWallet(_teamWallets[i]);
    }
    console.log("Admin deployed to:", admin.address);
    // deploy Downline NFT
    DownlineNFT = await ethers.getContractFactory("DownlineNFT");
    downlinenft = await DownlineNFT.deploy();
    await admin.setDownlineNFT(downlinenft.address);
    await downlinenft.transferOwnership(admin.address);
    console.log("DownlineNFT deployed to:", downlinenft.address);
    // deploy Pool
    Pool = await ethers.getContractFactory("Pool");
    pool = await Pool.deploy();
    await admin.setPool(pool.address);
    await pool.transferOwnership(admin.address);
    console.log("Pool deployed to:", pool.address);
    // deploy Presale NFT
    PresaleNFT = await ethers.getContractFactory("PresaleNFT");
    presalenft = await PresaleNFT.deploy();
    await admin.setPresaleNFT(presalenft.address);
    await presalenft.setPaymentToken(mockusdc.address);
    await presalenft.transferOwnership(admin.address);
    console.log("PresaleNFT deployed to:", presalenft.address);
    // deploy Swap
    Swap = await ethers.getContractFactory("Swap");
    swap = await Swap.deploy();
    await admin.setSwap(swap.address);
    await swap.transferOwnership(admin.address);
    console.log("Swap deployed to:", swap.address);
    // deploy Token
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    await admin.setToken(token.address);
    await token.transferOwnership(admin.address);
    console.log("Token deployed to:", token.address);
    // deploy Vault
    Vault = await ethers.getContractFactory("Vault");
    vault = await Vault.deploy();
    await admin.setVault(vault.address);
    await vault.transferOwnership(admin.address);
    console.log("Vault deployed to:", vault.address);
    await admin.unpausePresaleNFT();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
