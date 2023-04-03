// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract WeatherDataFeed is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    int public temperature;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 private gasLimit;

    constructor() {
        setPublicChainlinkToken();
        oracle = 0xCC79157eb46F5624204f47AB42b3906cAA40eaB7; // Oracle address for Goerli testnet
        jobId = "d8b15c43fbce49988dc3b5eade9d9ba1"; // Job ID for getting temperature from OpenWeatherMap
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        gasLimit = 1000000; // Set the gas limit to 1 million
    }

    function requestTemperature() public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("get", "https://api.openweathermap.org/data/2.5/weather");
        req.add("queryParams", "q=Chicago&appid=b231c2d3c617ae0c0564d80582e9f29a&units=imperial");
        req.add("path", "main.temp");
        sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(bytes32 _requestId, int _temperature) public recordChainlinkFulfillment(_requestId) {
        temperature = _temperature;
    }
}
