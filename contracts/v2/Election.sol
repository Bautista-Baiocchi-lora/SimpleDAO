// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/IElection.sol";
import "../../interfaces/IProposal.sol";
import "../../interfaces/IVault.sol";

contract Election is IElection {

    address private proposal;
    uint256 private start_block;
    uint256 private end_block;
    uint256 private total_support;
    uint256 private required_support;
    mapping(address => IElection.Ballot) public ballots;
    IERC20 private token;
    IVault private vault;

    modifier isAlive {
        require(block.number < end_block, "Election::Voting has closed.");
        _;
    }

    modifier hasNotVoted {
        require(ballots[msg.sender].stake == 0, "Election::Wallet has voted already.");
        _;
    }

    constructor(IElection.ElectionParams memory params){
        require(params.token != address(0), "Election::ERC20 address null.");
        require(params.proposal != address(0), "Election::Proposal address null.");
        require(params.vault != address(0), "Election::Vault address null.");
        require(IProposal(params.proposal).isPassed(), "Election::Proposal is not passed.");
        require(IVault(params.vault).getAcceptedToken() == params.token, "Election::Incompatible vault.");

        token = IERC20(params.token);
        vault = IVault(params.vault);
        proposal = params.proposal;
        start_block = params.start_block;
        end_block = params.end_block;
        required_support = params.required_support;
    }

    function vote(uint256 amount, Vote choice) public payable hasNotVoted isAlive {
        require(token.balanceOf(msg.sender) < amount, "Election::Insufficient balance.");
        vault.storeFunds(payable(msg.sender), amount);
        
        total_support += amount;
        ballots[msg.sender] = IElection.Ballot({stake: amount, vote: choice});

        emit IElection.newVote(msg.sender, choice, amount);
    }

    function isUpForVote() override public view returns (bool) {
        return block.number < end_block;
    }

    function isPassing() override public view returns (bool) {
        return total_support > required_support;
    }

    function isPassed() override public view returns(bool) {
        return !isUpForVote() && isPassing();
    }

    function getStartBlock() override external view returns(uint256){
        return start_block;
    }

    function getEndBlock() override external view returns(uint256){
        return end_block;
    } 


}

