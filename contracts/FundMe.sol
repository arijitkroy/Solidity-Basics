// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import { PriceConverter } from "./PriceConverter.sol";

// 656427
// 636085
// 612938
// 536562
error notOwner();
error callFailed();
error min5Usd();

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
}