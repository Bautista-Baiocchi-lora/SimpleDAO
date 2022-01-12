// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "./IProposal.sol";

interface IVotingStation {


    struct Ballot {
        uint256 amount;
        IProposal.VoteOption choice;
    }
}