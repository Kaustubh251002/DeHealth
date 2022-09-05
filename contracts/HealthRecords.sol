//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Doctor.sol";
import "./Patient.sol";
import "./Record.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract HealthRecords is Doctor, Patient, Record, Ownable {
    address private Owner;

    constructor() {
        Owner = msg.sender;
    }

    modifier fileAccess(
        address id,
        bytes32 fileHash,
        address patient
    ) {
        string memory role;
        (, role) = checkUser(id);
        uint256 index;
        if (
            keccak256(abi.encodePacked(role)) ==
            keccak256(abi.encodePacked("doctor"))
        ) {
            require(patToDoc[patient][id] > 0);
            index = patToRecord[patient][fileHash];
            require(index > 0);
        } else if (
            keccak256(abi.encodePacked(role)) ==
            keccak256(abi.encodePacked("patient"))
        ) {
            index = patToRecord[id][fileHash];
            require(index > 0);
        }
        _;
    }

    function checkUser(address _user)
        public
        view
        onlyOwner
        returns (string memory, string memory)
    {
        pat memory p = patientList[_user];
        doc memory d = doctorsList[_user];
        if (p.pat_addr > address(0)) return (p.name, "patient");
        else if (d.doc_addr > address(0)) return (d.name, "doctor");
        return ("", "");
    }

    function docToPatAccess(address docid)
        public
        checkPat(msg.sender)
        checkDoc(docid)
    {
        pat memory p = patientList[msg.sender];
        doc memory d = doctorsList[docid];
        require(patToDoc[msg.sender][docid] == 0);
        p.doctors[p.doctors.length] = docid;
        patToDoc[msg.sender][docid] = p.doctors.length - 1;
        d.patients[d.patients.length] = msg.sender;
    }

    function addRecord(
        string memory _fname,
        string memory _ftype,
        bytes32 _fileHash
    ) public checkPat(msg.sender) {
        pat memory p = patientList[msg.sender];
        require(patToRecord[msg.sender][_fileHash] == 0);
        filesList[_fileHash] = file({fileName: _fname, fileType: _ftype});
        p.records[p.records.length] = _fileHash;
        patToRecord[msg.sender][_fileHash] = p.records.length - 1;
    }

    function getPatientForDoc(address pat_addr)
        public
        view
        checkPat(pat_addr)
        checkDoc(msg.sender)
        returns (
            string memory,
            uint8,
            address,
            bytes32[] memory
        )
    {
        pat memory p = patientList[pat_addr];
        require(patToDoc[pat_addr][msg.sender] > 0);
        return (p.name, p.age, p.pat_addr, p.records);
    }

    function getFileForDoc(
        address docid,
        address patid,
        bytes32 fileHash
    )
        public
        view
        onlyOwner
        checkPat(patid)
        checkDoc(docid)
        fileAccess(docid, fileHash, patid)
        returns (string memory, string memory)
    {
        file memory f = filesList[fileHash];
        return (f.fileName, f.fileType);
    }

    function getFileForPat(address patid, bytes32 fileHash)
        public
        view
        onlyOwner
        checkPat(patid)
        fileAccess(patid, fileHash, patid)
        returns (string memory, string memory)
    {
        file memory f = filesList[fileHash];
        return (f.fileName, f.fileType);
    }
}
