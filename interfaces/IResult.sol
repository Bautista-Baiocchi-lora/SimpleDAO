// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface Result {

    struct Summary {
        bool passed;
        uint256 end_block;
        uint256 total_support;
        uint256 required_support;
        mapping(address => bool) pledges;
    }

}