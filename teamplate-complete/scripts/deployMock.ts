import { ethers } from "hardhat";

async function main() {
  

  const NFT = await ethers.getContractFactory("MockV3Aggregator");
  const nft = await NFT.deploy(8,1000000);

  await nft.deployed();

  console.log("NFT deployed to:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
