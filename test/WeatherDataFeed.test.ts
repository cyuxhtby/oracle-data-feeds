import { ethers} from "hardhat";
import { EventFilter } from "ethers";

describe("WeatherDataFeed", function () {
  it("Should request and fulfill temperature", async function () {
    // Get the factory for the WeatherDataFeed contract
    const WeatherDataFeed = await ethers.getContractFactory("WeatherDataFeed");

    // Deploy an instance of the WeatherDataFeed contract
    const weatherDataFeed = await WeatherDataFeed.deploy();


    // Request the temperature from OpenWeatherMap using Chainlink and set a gas limit
    await weatherDataFeed.requestTemperature({
        gasLimit: 1000000,
    });

    // Define the fulfillment event filter
    const filter: EventFilter = {
        address: weatherDataFeed.address,
        topics: [ethers.utils.id("fulfillment(bytes32,int256)")],
      };
  
      // Wait for the Chainlink fulfillment event to be emitted
      const [fulfillmentEvent] = await weatherDataFeed.queryFilter(filter);
  

    // Extract the temperature from the Chainlink fulfillment event
    const temperature = fulfillmentEvent.args[1];

    // Log the temperature to the console
    console.log(`Temperature: ${temperature}`);

  });
});
