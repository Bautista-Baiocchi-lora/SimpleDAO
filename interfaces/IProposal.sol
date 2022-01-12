// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IProposal {

    struct ProposalParams {
        uint256 _start_block;
        uint256 _end_block;
        uint256 _required_support;
    }

    struct Result {
        bool passed;
        uint256 end_block;
        uint256 total_support;
        uint256 required_support;
        mapping(address => bool) pledges;
    }

    function isPassing() external view returns (bool);

    function isUpForVote() external view returns (bool);

    function isPassed() external view returns(bool);

    function pledgeSupport() external;

    function unpledgeSupport() external;

    function getStartBlock() external view returns(uint256);

    function getEndBlock() external view returns(uint256);
    
    function getRequiredSupport() external view returns(uint256);

    function getTotalSupport() external view returns(uint256);

}