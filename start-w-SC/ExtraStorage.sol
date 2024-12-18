// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage{
    // SS + 5 -> override -> virtual override
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}