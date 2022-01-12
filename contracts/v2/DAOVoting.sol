// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


contract DAOVoting {

    enum Vote {
        POSITIVE,
        NEGATIVE
    }

    event newVote(address voter, Vote choice, uint256 pledge);

    uint256 public end_block;
    uint256 public total_support;
    uint256 public required_support;
    mapping(address => uint256) public tokens_pledged;
    mapping(address => Vote) public votes;

    modifier isAlive {
        require(block.number < end_block, "DAOVoting::Voting has closed.");
        _;
    }

    modifier hasNotVoted {
        require(tokens_pledged[msg.sender] == 0, "DAOVoting::Wallet has voted already.");
        _;
    }

    constructor(uint256 _end_block, uint256 _required_support){
        end_block = _end_block;
        required_support = _required_support;
    }

    function vote(Vote choice) public hasNotVoted isAlive {
        uint256 amount = 10000;
        tokens_pledged[msg.sender] = amount;
        total_support += amount;
        votes[msg.sender] = choice;

        emit newVote(msg.sender, choice, amount);
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

}

