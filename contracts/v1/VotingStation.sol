// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../interfaces/IVotingStation.sol";
import "../../interfaces/IProposal.sol";

contract VotingStation is IVotingStation{

    uint256 public start_block;
    uint256 public end_block;
    address public proposal;

    mapping(address => IVotingStation.Ballot) public votes;


    constructor(address _proposal){
        proposal = _proposal;
    }


    modifier isOpen() {
        require(block.number > start_block, "VotingStation::Voting hasn't opened yet.");
        require(block.number < end_block, "VotingStation::Voting is closed.");
        _;
    }

    function castVote(uint256 amount, uint8 choice) public isOpen {
        IProposal proposalContract = IProposal(proposal);
        IProposal.VoteOption memory voteChoice = proposalContract.getVoteOption(choice);

        //todo: check sender has ERC20 > amount
        votes[msg.sender] = IVotingStation.Ballot({amount: amount, choice: voteChoice});
    }



}