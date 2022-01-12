// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IElection {

    struct ElectionParams {
        address token;
        address vault;
        address proposal;
        uint256 start_block;
        uint256 end_block;
        uint256 required_support;
    }

    enum Vote {
        POSITIVE,
        NEGATIVE
    }

    struct Ballot {
        uint256 stake;
        Vote vote;
    }

    event newVote(address voter, Vote choice, uint256 stake);

    function getStartBlock() external view returns(uint256);

    function getEndBlock() external view returns(uint256);

    function isPassing() external view returns(bool);

    function isUpForVote() external view returns(bool);

    function isPassed() external view returns(bool);

}

