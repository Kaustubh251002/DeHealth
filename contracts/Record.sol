//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Record {
    struct file {
        string fileName;
        string fileType;
    }
    mapping(bytes32 => file) internal filesList;

    function fileInfo(bytes32 filehash) internal view returns (file memory) {
        require(bytes(filesList[filehash].fileName).length > 0);
        return filesList[filehash];
    }
}
