// SPDX-License-Identifier: MIT

// there are several global vars like msg.value that we can access always

pragma solidity ^0.8.22;

import "./priceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor(){
        owner = msg.sender;

    }

    function fund() public payable { // payable is required when we want to send tokens with a fun
        // set min fund value in USD
        // 1. How to send ETH to this contract? contracts can hold funds as wallets
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough"); // in wei
        funders.push(msg.sender); // msg.sender is the address of whatever alls the function
        addressToAmountFunded[msg.sender] = msg.value;
    }
    //
    
    function withdraw() public onlyOwner {

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // withdraw funds

        // 1. transfer
        // payable(msg.sender).transfer(address(this).balance);
        // 2. send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // 3. call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Sender is not owner");
        _; // do the require and then the rest of the code for the fucntion
    }

    
// REVERT: undo any activity before, and send remaining gas fee. require: if condition is false, revertthe action in the function
}