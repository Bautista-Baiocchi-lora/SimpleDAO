

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/access/Ownable.sol";

import "./DAOProposal.sol";

contract DAO is Ownable{
    uint256 constant private time_horizon = 1000;

    enum State {
        FRESH, PROPOSAL, VOTE, RESULT
    }

    State public STATE;
    DAOProposal public proposal;

    bytes32 private title;
    string private info;
    uint256 start_block;

    modifier isState(State _state){
        require(STATE == _state, "DAO::Invalid state transition.");
        _;
    }

    modifier proposalPassed {
        require(proposal.isPassed(), "DAO:Proposal did not pass.");
        _;
    }


    constructor(
        bytes32 _title,
        string memory _info
        ){
            title = _title;
            info = _info;
            STATE = State.FRESH;
        }

    function intatiate() public onlyOwner isState(State.FRESH) {
        start_block = block.number;
        STATE = State.PROPOSAL;

        proposal = new DAOProposal(start_block + time_horizon, 10000);
    }

    function startVote() public onlyOwner isState(State.PROPOSAL) proposalPassed {
        
    }


}