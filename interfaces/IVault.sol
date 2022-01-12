// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IVault {

    event FundsDeposited(address depositor, address token, uint256 amount);

    function releaseAllFunds() external;

    function storeFunds(uint256 amount) external payable;

}
