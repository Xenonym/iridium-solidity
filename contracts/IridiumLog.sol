pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/MerkleProof.sol';

contract IridiumLog {
	address admin;
	address customer;

	bytes32 public currentRoot;
	bytes32 constant public genesis = 0xe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855;
	
	event LogRootUpdated(bytes32 oldRoot, bytes32 newRoot);

	function IridiumLog() public {
		admin = msg.sender;
		customer = msg.sender;
		currentRoot = genesis;
	}

	function updateRoot(bytes32 newRoot, bytes32 prevLeaf, bytes proof) public onlyCustomer {
	    require(MerkleProof.verifyProof(proof, newRoot, prevLeaf));
	    bytes32 oldRoot = currentRoot;
	    currentRoot = newRoot;
	    LogRootUpdated(oldRoot, newRoot);
	}
	
	function verifyRoot(bytes32 root) public view returns (bool) {
	    return root == currentRoot;
	}

	function verifyInclusion(bytes proof, bytes32 leaf) public view returns (bool) {
	    return MerkleProof.verifyProof(proof, currentRoot, leaf);
	}
	
	function closeLog() public onlyCustomer {
	    selfdestruct(admin);
	}
	
	modifier onlyCustomer() {
		require(msg.sender == customer);
		_;
	}
	
	modifier onlyAdmin() {
	    require(msg.sender == admin);
	    _;
	}
}
