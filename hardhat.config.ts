import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const { PRIVATE_KEY, INFURA_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY]
    }
  },
  defaultNetwork: "sepolia"
};
