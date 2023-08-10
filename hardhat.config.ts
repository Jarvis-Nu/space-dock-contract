const dotenv = require("dotenv")
require("@nomicfoundation/hardhat-toolbox");

dotenv.config()

const config = {
  solidity: "0.8.19",
  networks: {
    goerli: {
      url: "https://goerli.optimism.io",
      accounts: [process.env.PRIVATE_KEY], // Use your private key here
      ovm: true,
    },
  }
};

module.exports = config
