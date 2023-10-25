require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.22",
  networks: {
  polygon_mumbai: {
    url: `https://polygon-mumbai.g.alchemy.com/v2/mkeLM7cdhQ2dgyb4unpBtr12XPs4t18w`,
    accounts: [`0x6893f55d6abbc13eef5ac314c2feb9e049dbdf4fd6d9454bc775c2f1da480006`],
  },
}
};