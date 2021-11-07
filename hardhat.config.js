require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

const API_KEY = process.env.PROJECT_ID;

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${API_KEY}`,
      accounts: [],
    },
  },
};
