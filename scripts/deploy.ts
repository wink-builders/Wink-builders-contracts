const { ethers, upgrades } = require("hardhat");

async function main() {
    const TechnologiesSBT = await ethers.getContractFactory("TechnologiesSBT");
    const technologiesSBT = await upgrades.deployProxy(TechnologiesSBT);
    // const technologiesSBT = await TechnologiesSBT.deploy();
    await technologiesSBT.deployed();
    console.log("TechnologiesSBT deployed to:", technologiesSBT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
