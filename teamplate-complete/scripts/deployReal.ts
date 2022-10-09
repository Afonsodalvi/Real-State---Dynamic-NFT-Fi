import { ethers } from "hardhat";

async function main() {
  

  const enderecoTokenreward = "0x04f5b206925f159f0d7773f77964Dad8F3C59d1B";
  const Mock= "0x43e8DEfb58FEf865eF14CFfBA39830724BED33c8";
  const NFT = await ethers.getContractFactory("RealStNFTFi");
  const nft = await NFT.deploy(10,Mock,enderecoTokenreward,200000);

  await nft.deployed();

  console.log("Real state deployed to:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
