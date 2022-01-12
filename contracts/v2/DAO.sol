// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../interfaces/IDAO.sol";
import "../../interfaces/IProposal.sol";
import "../../interfaces/IElection.sol";
import "../../interfaces/IVault.sol";

import "./Election.sol";
import "./Proposal.sol";
import "./Vault.sol";

contract DAO is IDAO, Ownable{
    uint256 constant private time_horizon = 1000;

    IDAO.State public STATE;
    IProposal public proposal;
    IElection public election;
    IVault public vault;

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

    modifier electionFinished {
        require(!election.isUpForVote(), "DAO::Election is not finished.");
        _;
    }

    constructor(IDAO.DAOParams memory params){
            require(params.token != address(0) ,"DAO::Token address null.");

            token = IERC20(params.token);   
            start_block = block.number;
            STATE = IDAO.State.FRESH;
        }

    function intatiateProposal(bytes32 title, string memory info) public onlyOwner isState(State.FRESH) {
        STATE = IDAO.State.PROPOSAL;

        //create proposal
        proposal = Factory.proposal(title, info, time_horizon, 1000);
        emit IDAO.ProposalStarted(proposal.getStartBlock(), proposal.getEndBlock());
    }

    function startElection() public onlyOwner isState(State.PROPOSAL) proposalPassed {
        emit IDAO.ProposalFinished(proposal.isPassed(), proposal.getTotalSupport());
        STATE = IDAO.State.ELECTION;

        //create vault to store DAO tokens during election
        vault = Factory.vault(address(token));
        emit IDAO.VaultCreated(address(token), address(this));

        //create election
        election = Factory.election(address(token), address(vault), address(proposal), time_horizon, token.totalSupply() / 2 + 1);
        emit IDAO.ElectionStarted(election.getStartBlock());
    }

    function finishElection() public onlyOwner isState(State.ELECTION) electionFinished {
        emit IDAO.ElectionFinished(election.getEndBlock(), election.isPassed());
        STATE = IDAO.State.RESULT;

        //don't allow anymore deposits
        vault.pause();
        vault.releaseAllFunds();
    }


}

library Factory {

    function proposal(
        bytes32 _title,
        string memory _info,
        uint256 _horizon, 
        uint256 _required_support
        ) internal returns(Proposal){
        return new Proposal(IProposal.ProposalParams({
            title: _title,
            info: _info,  
            start_block: block.number,
            end_block: block.number + _horizon, 
            required_support: _required_support
        }));
    }

    function election(
        address _token, 
        address _vault,
        address _proposal,
        uint256 _horizon, 
        uint256 _required_support
        ) internal returns(Election){
        return new Election(IElection.ElectionParams({
            token: _token,
            vault: _vault,
            proposal: _proposal,
            start_block: block.number,
            end_block: block.number + _horizon,
            required_support: _required_support
        }));
    }

    function vault(
        address token
    ) internal returns(Vault){
        return new Vault(token);
    }


}