// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "../contracts/v2/Proposal.sol";

interface IDAO {

    event ProposalStarted(uint256 start_block, uint256 end_block);
    event ProposalFinished(bool passed, uint256 total_support);

    event ElectionStarted(uint256 start_block);
    event ElectionFinished(uint256 end_block, bool passed);

    event VaultCreated(address token, address owner);

    struct DAOParams {
        address token;
    }

    enum State {
        FRESH, PROPOSAL, ELECTION, RESULT
    }

    function getState() external view returns(State);

    function getGovernanceToken() external view returns(address);

    function getProposal() external view returns(Proposal);

}