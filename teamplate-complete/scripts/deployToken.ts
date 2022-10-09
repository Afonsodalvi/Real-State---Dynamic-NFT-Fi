import { ethers } from "hardhat";

async function main() {
  
  const quantidade = 1000000000;
  const NFT = await ethers.getContractFactory("RealTokreward");
  const nft = await NFT.deploy(quantidade);

  await nft.deployed();

  console.log("RealTokreward deployed to:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
