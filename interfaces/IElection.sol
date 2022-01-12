// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IElection {

    struct ElectionParams {
        address _token;
        address _proposal;
        uint256 _start_block;
        uint256 _end_block;
        uint256 _required_support;
    }

    enum Vote {
        POSITIVE,
        NEGATIVE
    }

    event newVote(address voter, Vote choice, uint256 stake);

    function getStartBlock() external view returns(uint256);

    function getEndBlock() external view returns(uint256);

}

