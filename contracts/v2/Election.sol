// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/IElection.sol";
import "../../interfaces/IProposal.sol";

contract Election is IElection {

    address private proposal;
    uint256 private start_block;
    uint256 private end_block;
    uint256 private total_support;
    uint256 private required_support;
    mapping(address => uint256) public tokens_pledged;
    mapping(address => Vote) public votes;
    IERC20 private token;

    modifier isAlive {
        require(block.number < end_block, "Election::Voting has closed.");
        _;
    }

    modifier hasNotVoted {
        require(tokens_pledged[msg.sender] == 0, "Election::Wallet has voted already.");
        _;
    }

    constructor(IElection.ElectionParams memory params){
        require(params._token != address(0), "Election::ERC20 address null.");
        require(params._proposal != address(0), "Election::Proposal address null.");
        require(IProposal(proposal).isPassed(), "Election::Proposal is not passed.");

        token = IERC20(params._token);
        proposal = params._proposal;
        start_block = params._start_block;
        end_block = params._end_block;
        required_support = params._required_support;
    }

    function vote(uint256 amount, Vote choice) public payable hasNotVoted isAlive {
        require(token.balanceOf(msg.sender) < amount, "Election::Insufficient balance.");
        tokens_pledged[msg.sender] = amount;
        total_support += amount;
        votes[msg.sender] = choice;

        emit IElection.newVote(msg.sender, choice, amount);
    }

    function isUpForVote() public view returns (bool) {
        return block.number < end_block;
    }

    function isPassing() public view returns (bool) {
        return total_support > required_support;
    }

    function isPassed() public view returns(bool) {
        return !isUpForVote() && isPassing();
    }

    function getStartBlock() override external view returns(uint256){
        return start_block;
    }

    function getEndBlock() override external view returns(uint256){
        return end_block;
    } 


}

