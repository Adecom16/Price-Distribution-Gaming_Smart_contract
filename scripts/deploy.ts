import { ethers } from "hardhat";

async function main() {


  const PrizeDistributionFactory = await ethers.deployContract("PrizeDistributionFactory");

  await PrizeDistributionFactory.waitForDeployment();

  console.log(
    `PrizeDistributionFactory deployed to ${PrizeDistributionFactory.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
