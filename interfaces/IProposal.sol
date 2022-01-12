// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IProposal {

    struct ProposalParams {
        uint256 _end_block;
        uint256 _required_support;
    }

}