// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract SimpleStorage {
    uint256 favNum;
    
    struct Person {
        uint256 favNm;
        string name;
    }

    Person[] public listOfPeople;
    mapping(string => uint256) public nameToFavNum;
    
    function store(uint256 _favNum) public virtual {
        favNum = _favNum;
    } 

    function retrieve() public view returns(uint256) {
        return favNum;
    }

    function addPerson(string memory _name, uint256 _favNum) public {
        listOfPeople.push(Person(_favNum, _name));
        nameToFavNum[_name] = _favNum;
    }
}