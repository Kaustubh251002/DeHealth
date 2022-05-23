pragma solidity ^0.8.0;

contract records{
    struct patient{
        string name;
        uint8 age;
        uint256 pid;
        
    }
    mapping(address=>patient) patientByAddress;
    
}