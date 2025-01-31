// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// import { PriceConverter } from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error notOwner();
error callFailed();
error min5Usd();

library PriceConverter {
    // address constant addr = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant addr = 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF;

    function GetVersion() internal view returns(uint256) {
        return AggregatorV3Interface(addr).version();
    }

    function GetPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(addr);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function GetConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = GetPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    address public immutable i_owner;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded; 

    constructor() {
        i_owner = msg.sender;
    }

    function Fund() public payable {
        // require(msg.value.GetConversionRate() >= MINIMUM_USD, "Minimum 5$ needed!");
        if(msg.value.GetConversionRate() < MINIMUM_USD) revert min5Usd();
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function Withdraw() public onlyi_owner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //payable(msg.sender).transfer(address(this).balance);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        //require(callSuccess, "Call Failed");
        if (!callSuccess) revert callFailed();
    }

    modifier onlyi_owner() {
        // require(msg.sender == i_owner, "Not an Owner");
        if(msg.sender != i_owner) revert notOwner();
        _;
    }

    receive() external payable {
        Fund();
    }

    fallback() external payable {
        Fund();
    }
}