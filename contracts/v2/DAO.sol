// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../interfaces/IDAO.sol";
import "../../interfaces/IProposal.sol";
import "./Proposal.sol";

contract DAO is IDAO, Ownable{
    uint256 constant private time_horizon = 1000;

    IDAO.State public STATE;
    Proposal public proposal;

    IERC20 private token;
    bytes32 private title;
    string private info;
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
            title = params._title;
            info = params._info;        
            start_block = block.number;
            STATE = State.FRESH;
        }

    function intatiate() public onlyOwner isState(State.FRESH) {
        STATE = State.PROPOSAL;

        proposal = _createProposal();
    }

    function _createProposal() private returns(Proposal){
        return new Proposal(IProposal.ProposalParams({
            _end_block: block.number + time_horizon, 
            _required_support: 10000
            }));
    }

    function startVote() public onlyOwner isState(State.PROPOSAL) proposalPassed {
        
    }


}