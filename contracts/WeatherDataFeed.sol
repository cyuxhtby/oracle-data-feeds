// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract WeatherDataFeed is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    int public temperature;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 private gasLimit;
    string private apiKey;

    constructor(string memory _apiKey) {
        setPublicChainlinkToken();
        oracle = 0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD; // Oracle address for Sepolia testnet
        jobId = "7223acbd01654282865b678924126013"; // Job ID for getting temperature from OpenWeatherMap
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        gasLimit = 3000000; // Set the gas limit to 1 million
        apiKey = _apiKey;
    }

    modifier onlyOracle {
        require(msg.sender == oracle, "Caller is not the oracle");
        _;
    }

    function requestTemperature(string memory city) public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        string memory url = string(abi.encodePacked("https://api.openweathermap.org/data/2.5/weather?q=", city, "&appid=", apiKey, "&units=imperial"));
        req.add("get", url);
        req.add("path", "main.temp");
        sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(bytes32 _requestId, int _temperature) public recordChainlinkFulfillment(_requestId) onlyOracle {
        temperature = _temperature;
    }
}
