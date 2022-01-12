// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DAOProposal {

    event newPledge(address pledged);
    event unPledged(address unpledged);

    uint256 public end_block;
    uint256 public total_support;
    uint256 public required_support;
    mapping(address => bool) public pledges;

    modifier isAlive {
        require(block.number < end_block, "DAOPropostal::Proposal has closed.");
        _;
    }

    modifier isNotPledged {
        require(pledges[msg.sender] == false, "DAOProposol::Wallet has already pledged.");
        _;
    }

    modifier isPledged {
        require(pledges[msg.sender] == false, "DAOProposol::Wallet has already pledged.");
        _;
    }

    constructor(uint256 _end_block, uint256 _required_support){
        end_block = _end_block;
        required_support = _required_support;
    }

    function pledgeSupport() public isNotPledged isAlive {
        pledges[msg.sender] = true;
        total_support += 1;

        emit newPledge(msg.sender);
    }

    function unpledgeSupport() public isPledged isAlive {
        pledges[msg.sender] = false;
        total_support -= 1;

        emit unPledged(msg.sender);
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