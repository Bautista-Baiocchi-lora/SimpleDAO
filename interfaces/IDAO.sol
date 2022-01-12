// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


interface IDAO {

    struct DAOParams {
        address _token;
        bytes32 _title;
        string _info;
    }

    enum State {
        FRESH, PROPOSAL, VOTE, RESULT
    }

}