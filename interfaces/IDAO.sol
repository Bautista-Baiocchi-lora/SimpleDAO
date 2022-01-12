// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IDAO {

    event ProposalStarted(uint256 start_block, uint256 end_block);
    event ProposalFinished(bool passed, uint256 total_support);

    event ElectionStarted(uint256 start_block);

    struct DAOParams {
        address _token;
    }

    enum State {
        FRESH, PROPOSAL, ELECTION, RESULT
    }

}