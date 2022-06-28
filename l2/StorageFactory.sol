pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage {
    SimpleStorage[] public SimpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        SimpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorage, uint256 _simpleStorageNumber) public {
        //Address 
        //ABI
        //this line has an explicit cast to the address type and initializes a new simplestorage object from the address

        SimpleStorageArray(address(simpleStorage[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        //this line has an explicit cast to the address type and initializes a new simple storage object from the address
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}