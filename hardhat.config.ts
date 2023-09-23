import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";

import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@openzeppelin/hardhat-upgrades";
import "@typechain/hardhat";

import "hardhat-contract-sizer";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
      blockGasLimit: 12e6,
      allowUnlimitedContractSize: true,
    },
    baseGoerli: {
      url: process.env.BASE_GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY_BASE_GOERLI !== undefined
          ? [process.env.PRIVATE_KEY_BASE_GOERLI]
          : [],
    },
    localhost: {
      gas: 12e6,
      blockGasLimit: 12e6,
      // gasPrice: 8e8,
      // gasMultiplier: 0.5,
      url: "http://0.0.0.0:8545",
    },
  },
  defaultNetwork: "hardhat",
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    gasPrice: 30,
    showTimeSpent: true,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY || "",
  },
};

export default config;
