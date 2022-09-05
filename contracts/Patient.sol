//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

contract Patient {
    struct pat {
        string name;
        uint8 age;
        address pat_addr;
        bytes32[] records;
        address[] doctors;
    }

    mapping(address => pat) internal patientList;
    mapping(address => mapping(address => uint256)) internal patToDoc;
    mapping(address => mapping(bytes32 => uint256)) internal patToRecord;

    modifier checkPat(address id) {
        require(patientList[id].pat_addr > address(0));
        _;
    }

    function patInfo()
        public
        view
        checkPat(msg.sender)
        returns (
            string memory,
            uint8,
            address[] memory,
            bytes32[] memory
        )
    {
        pat memory p = patientList[msg.sender];
        return (p.name, p.age, p.doctors, p.records);
    }

    function newPatient(string memory _name, uint8 _age) public {
        pat memory p = patientList[msg.sender];
        require(
            _age > 0 &&
                _age < 100 &&
                keccak256(abi.encodePacked(_name)) !=
                keccak256(abi.encodePacked(""))
        );
        require(p.pat_addr == address(0));
        patientList[msg.sender] = pat({
            name: _name,
            age: _age,
            pat_addr: msg.sender,
            records: new bytes32[](0),
            doctors: new address[](0)
        });
    }
}
