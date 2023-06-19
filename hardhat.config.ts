import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();

const testnetDeployerPk = process.env.TESTNET_DEPLOYER_PRIVATE_KEY;
if (!testnetDeployerPk) {
    throw new Error("Must set a deployer pk");
}
task("mint", "Mint new nft")
    .addParam("contractAddress", "Address of the ERC1155 contract")
    .addParam("metadataUri", "Uri for the metadata")
    .addParam("receiverAddress", "Address of the recipient of the token")
    .addParam("tokenId", "Id to use on the new nft")
    .setAction(async (taskArgs) => {
        const [minter] = await ethers.getSigners();
        const contract = await ethers.getContractAt(
            "TechnologiesSBT",
            taskArgs.contractAddress,
            minter
        );
        const tokenId = parseInt(taskArgs.tokenId);
        let res = await contract.setTokenUri(tokenId, taskArgs.metadataUri);
        await res.wait();
        res = await contract.mint(taskArgs.receiverAddress, tokenId);
        console.log(await res.wait());
    });
const config: HardhatUserConfig = {
    solidity: "0.8.18",
    networks: {
        sepolia: {
            url: `${process.env.SEPOLIA_NODE_URL}`,
            accounts: [testnetDeployerPk],
        },
        goerli: {
            url: `${process.env.GOERLI_NODE_URL}`,
            accounts: [testnetDeployerPk],
        },
        lachain: {
            url: `${process.env.LACHAIN_NODE_URL}`,
            accounts: [testnetDeployerPk],
        },
        fuji: {
            url: `${process.env.FUJI_NODE_URL}`,
            accounts: [testnetDeployerPk],
        },
        rsk_testnet: {
            url: `${process.env.RSK_TESTNET_NODE_URL}`,
            accounts: [testnetDeployerPk],
        },
    },
};

export default config;
