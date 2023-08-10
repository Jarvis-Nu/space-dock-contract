const { ethers } = require("hardhat");

async function main() {
  const factory = await ethers.getContractFactory("SpaceDock");
  const contract = await factory.deploy();
  console.log("address: ", await contract.getAddress())
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
