// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


contract IElection {

    struct ElectionParams {
        address _token;
        uint256 _end_block;
        uint256 _required_support;
    }

    enum Vote {
        POSITIVE,
        NEGATIVE
    }

    event newVote(address voter, Vote choice, uint256 pledge);

}

