const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const CandleAuction = await hre.ethers.getContractFactory("CandleAuction");
  
  // Deploy the contract
  const candleAuction = await CandleAuction.deploy();
  
  await candleAuction.deployed();
  
  console.log("CandleAuction deployed to:", candleAuction.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
