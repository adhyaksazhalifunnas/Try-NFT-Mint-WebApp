const hre = require("hardhat");

async function main() {

  const NanameNFT = await hre.ethers.getContractFactory("NanameNFT");
  const nanameNFT = await NanameNFT.deploy();

  await nanameNFT.deployed();

  console.log(
    `NanameNFT deployed to ${nanameNFT.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
