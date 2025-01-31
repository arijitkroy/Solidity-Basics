// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { SimpleStorage } from "contracts/SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStore(uint256 _ssIndex, uint256 _ssNumber) public {
        listOfSimpleStorageContracts[_ssIndex].store(_ssNumber);
    }

    function sfGet(uint256 _ssIndex) public view returns(uint256) {
        return listOfSimpleStorageContracts[_ssIndex].retrieve();
    }
}