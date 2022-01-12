// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../interfaces/IProposal.sol";

contract Proposal is IProposal {

    event newPledge(address pledged);
    event unPledged(address unpledged);

    uint256 private _end_block;
    uint256 private _start_block;
    uint256 private _total_support;
    uint256 private _required_support;
    mapping(address => bool) public pledges;

    modifier isAlive {
        require(block.number < _end_block, "Proposal::Proposal has closed.");
        _;
    }

    modifier isNotPledged {
        require(pledges[msg.sender] == false, "Proposal::Wallet has already pledged.");
        _;
    }

    modifier isPledged {
        require(pledges[msg.sender] == false, "Proposal::Wallet has already pledged.");
        _;
    }

    constructor(IProposal.ProposalParams memory params){
        _start_block = params._start_block;
        _end_block = params._end_block;
        _required_support = params._required_support;
    }

    function pledgeSupport() override public isNotPledged isAlive {
        pledges[msg.sender] = true;
        _total_support += 1;

        emit newPledge(msg.sender);
    }

    function unpledgeSupport() override public isPledged isAlive {
        pledges[msg.sender] = false;
        _total_support -= 1;

        emit unPledged(msg.sender);
    }

    function isUpForVote() override public view returns (bool) {
        return block.number < _end_block;
    }

    function isPassing() override public view returns (bool) {
        return _total_support > _required_support;
    }

    function isPassed() override public view returns(bool) {
        return !isUpForVote() && isPassing();
    }

    function getStartBlock() override external view returns(uint256){
        return _start_block;
    }

    function getEndBlock() override external view returns(uint256){
        return _end_block;
    } 

    function getRequiredSupport() override external view returns(uint256){
        return _required_support;
    }

    function getTotalSupport() override external view returns(uint256){
        return _total_support;
    }

}