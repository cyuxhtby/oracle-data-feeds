require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  const apiKey = process.env.OPEN_WEATHER_API_KEY;

  if (!apiKey) {
    console.error("API_KEY is not defined in the .env file.");
    process.exit(1);
  }

  const WeatherDataFeedFactory = await ethers.getContractFactory("WeatherDataFeed");
  const weatherDataFeed = await WeatherDataFeedFactory.deploy(apiKey, { gasLimit: 3000000 });

  console.log("Deploying WeatherDataFeed...");
  await weatherDataFeed.deployed();
  console.log("WeatherDataFeed deployed to:", weatherDataFeed.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
