// import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: ".env" });

const ALCHEMY_SEPOLIA_API_KEY_URL = process.env.ALCHEMY_SEPOLIA_API_KEY_URL;

const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url:
        ALCHEMY_SEPOLIA_API_KEY_URL ||
        "https://eth-sepolia.g.alchemy.com/v2/teS0W8W3d-kbFi9yX5bbRbXdjOMnEXXE",
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
    
  },
};
