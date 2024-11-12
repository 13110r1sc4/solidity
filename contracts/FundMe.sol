// get funds
// withdraw funds
// set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 50 * 1e18;

    function fund() public payable { // payable is required when we want to send tokens with a fun
        // set min fund value in USD
        // 1. How to send ETH to this contract? contracts can hold funds as wallets
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough"); // in wei
    
    }
    // function withdraw    

    function getPrice() public view returns(uint256) {
        // we need ABi of the external contract, and the address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // we could do it with an INTERFACE
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int price,,,) = priceFeed.latestRoundData(); // ETH in USD, returns number without decimals, count 8 decimals
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

// REVERT: undo any activity before, and send remaining gas fee. require: if condition is false, revertthe action in the function
}