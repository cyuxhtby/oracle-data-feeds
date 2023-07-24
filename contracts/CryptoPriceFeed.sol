// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CryptoPriceFeed {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Sepolia
     * BTC/USD - 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     * ETH/USD - 0x694AA1769357215DE4FAC081bf1f309aDC325306
     * LINK/USD - 0xc59E3633BAAC79493d908e63626716e204A45EdF
     */

    function setPriceFeed(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    // A round is a single unique attempt to get data from an oracle
    // It offers extra data regarding the request for security, accuracy etc.

    // A tuple is an array-like data structure that allows you to store a fixed number of values of different types as one variable.
    // latestRoundData returns a tuple with one of the values being the price (answer).
    // Tuples themselves return a hash of the tuple's contents, so and individual value must be specified. 

    function getPrice() public view returns (int) {
        (
        /* uint80 roundID */,
        int answer,
        /*uint startedAt*/,
        /*uint timeStamp*/,
        /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return answer;
    }
}