// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IVault {

    event FundsReleased(address recipient, address token, uint256 amount);
    event FundsDeposited(address depositor, address token, uint256 amount);

    function releaseAllFunds() external;

    function storeFunds(address payable sender, uint256 amount) external payable;

    function getAcceptedToken() external view returns(address token);

}
