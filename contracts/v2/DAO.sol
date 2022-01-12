// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../interfaces/IDAO.sol";
import "../../interfaces/IProposal.sol";
import "../../interfaces/IElection.sol";

import "./Election.sol";
import "./Proposal.sol";

contract DAO is IDAO, Ownable{
    uint256 constant private time_horizon = 1000;

    IDAO.State public STATE;
    IProposal public proposal;
    IElection public election;

    IERC20 private token;
    uint256 start_block;

    modifier isState(IDAO.State _state){
        require(STATE == _state, "DAO::Invalid state transition.");
        _;
    }

    modifier proposalPassed {
        require(proposal.isPassed(), "DAO::Proposal did not pass.");
        _;
    }

    constructor(IDAO.DAOParams memory params){
            require(params._token != address(0) ,"DAO::Token address null.");

            token = IERC20(params._token);   
            start_block = block.number;
            STATE = IDAO.State.FRESH;
        }

    function intatiateProposal(bytes32 title, string memory info) public onlyOwner isState(State.FRESH) {
        STATE = IDAO.State.PROPOSAL;

        proposal = Factory.proposal(title, info, time_horizon, 1000);
        emit IDAO.ProposalStarted(proposal.getStartBlock(), proposal.getEndBlock());
    }

    function startElection() public onlyOwner isState(State.PROPOSAL) proposalPassed {
        emit IDAO.ProposalFinished(proposal.isPassed(), proposal.getTotalSupport());
        STATE = IDAO.State.ELECTION;

        election = Factory.election(address(token), address(proposal), time_horizon, token.totalSupply() / 2 + 1);
        emit IDAO.ElectionStarted(election.getStartBlock());
    }


}

library Factory {

    function proposal(
        bytes32 title,
        string memory info,
        uint256 horizon, 
        uint256 required_support
        ) internal returns(Proposal){
        return new Proposal(IProposal.ProposalParams({
            _title: title,
            _info: info,  
            _start_block: block.number,
            _end_block: block.number + horizon, 
            _required_support: required_support
        }));
    }

    function election(
        address token, 
        address proposal,
        uint256 horizon, 
        uint256 required_support
        ) internal returns(Election){
        return new Election(IElection.ElectionParams({
            _token: token,
            _proposal: proposal,
            _start_block: block.number,
            _end_block: block.number + horizon,
            _required_support: required_support
        }));
    }


}