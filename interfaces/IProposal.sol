// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IProposal {

    struct VoteOption {
        uint8 id;
        bytes32 title;
    }

    function getVoteOption(uint8 id) view external returns(IProposal.VoteOption memory) ;

}