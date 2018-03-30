var IridiumLog = artifacts.require("IridiumLog");
var MerkleProof = artifacts.require("MerkleProof")

module.exports = function(deployer) {
  deployer.deploy(MerkleProof).then(() => {
  	deployer.link(MerkleProof, IridiumLog);
  	return deployer.deploy(IridiumLog);
  })
};
