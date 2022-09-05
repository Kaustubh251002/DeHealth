var Health = artifacts.require("HealthRecords.sol");

module.exports = function(deployer) {
  deployer.deploy(Health);
};
