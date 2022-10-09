import { ethers } from "hardhat";

async function main() {
  
  const Baseuri = "https://ipfs.io/ipfs/QmSxLQ6K7s3yvUWP4VpkBvhfyG1rJBcDY5gAKaScihAKxx/";
  const nome = "SBT-OMNES10";
  const symbol ="OMENSSBT";
  const hiddenMetadadaUri = "https://ipfs.io/ipfs/QmWCbaw4vp4m6QKqrkxtQe7A7tsir9WGMgVvZaagMzSe9W"


  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy(nome, symbol, Baseuri,hiddenMetadadaUri);

  await nft.deployed();

  console.log("NFT deployed to:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
