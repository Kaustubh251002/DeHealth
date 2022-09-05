//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Doctor {
    struct doc {
        string name;
        address doc_addr;
        address[] patients;
    }

    mapping(address => doc) internal doctorsList;
    mapping(address => mapping(address => uint256)) docToPat;

    modifier checkDoc(address id) {
        require(doctorsList[id].doc_addr > address(0));
        _;
    }

    function docInfo()
        public
        view
        checkDoc(msg.sender)
        returns (string memory, address[] memory)
    {
        doc memory d = doctorsList[msg.sender];
        return (d.name, d.patients);
    }

    function newDoctor(string memory _name) public {
        doc memory d = doctorsList[msg.sender];
        require(
            keccak256(abi.encodePacked(_name)) !=
                keccak256(abi.encodePacked(""))
        );
        require(d.doc_addr == address(0));
        doctorsList[msg.sender] = doc({
            name: _name,
            doc_addr: msg.sender,
            patients: new address[](0)
        });
    }
}
