// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

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