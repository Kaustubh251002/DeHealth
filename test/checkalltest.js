const ganache = require('ganache');
const Web3 = require('web3');
const HealthRecordContract = require('../build/contracts/HealthRecords.json');
const ContractRef = require('./contract_ref');
const server = ganache.server();
const web3 = new Web3();
let app;

let { abi, bytecode } = HealthRecordContract;
let contractRef = new ContractRef();

before((done) => {
    console.log('Deploying Health Record contract...');
    server.listen({port:8545,network_id:5777}, function(err/*, blockchain*/) {
        if(err)
            console.log(err);
        console.log('Ganache server started');

        web3.setProvider(new web3.providers.HttpProvider(process.env.HTTP_PROVIDER));

        web3.eth.getAccounts(async (error, accounts) => {
            if(error)
                console.log(error);

            contractRef.accounts = accounts;

            web3.eth.contract(JSON.parse(JSON.stringify(abi)))
            .new({from: accounts[0], gas: 4000000, data: bytecode}, (err, contract) => {
                if(err) {
                    console.log(err);
                    fail('Contract could not be Deployed!!');
                }
    
                console.log('Contract Deployed Successfully!! ^_^');
    
                if(contract.newDoctor && accounts) {
                    contractRef.healthRecord = contract;
                    contractRef.contractAddress = contract.address;
                    done();
                }
            });
        });
    });
});

describe('Check Registration', () => {

    before((done) => {
        console.log('Doctor Registration');
        contractRef.healthRecord.newDoctor
        .sendTransaction('Doc1',{"from":contractRef.accounts[1], gas: 100000}, (err, txn) => {
            if(err) {
                console.log(err);
                fail('signup doctor failed');
            }
            else {
                console.log('Doctor registration sucessfull. Address:'+contractRef.accounts[1]);
                contractRef.doctors.push(contractRef.accounts[1]);
                done();
            }
        });
    });

    before((done) => {
        console.log('PAtient Registration');
        contractRef.healthRecord.newPatient
        .sendTransaction('Pat1', 20, {"from":contractRef.accounts[2], gas: 100000}, (err, txn) => {
            if(err) {
                console.log(err);
                fail('signup patient failed');
            }
            else {
                console.log('Patient registration sucessfull. Address:'+ contractRef.accounts[2]);
                contractRef.patients.push(contractRef.accounts[2]);
                done();
            }
        });
    })

    test('Check doctor', (done) => {
        contractRef
        .healthRecord
        .docInfo
        .call({from: contractRef.accounts[1]}, (err, doc) => {
            if(err) {
                console.log(err);
                done.fail(err);
            }
            else {
                expect('Doc1').toEqual(doc[0]);
                console.log("Success!");
                done();
            }
        });
    });

    test('Check patient', (done) => {
        contractRef
        .healthRecord
        .patInfo
        .call({from: contractRef.accounts[2]}, (err, pat) => {
            if(err) {
                console.log(err);
                done.fail(err);
            }
            else {
                expect('patient1').toEqual(pat[0]);
                done();
            }
        });
    });

});