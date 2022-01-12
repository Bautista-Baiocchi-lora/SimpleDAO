// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../interfaces/IVault.sol";

contract Vault is IVault, Ownable {

    mapping(address => uint256) public deposits;
    address[] private wallets;
    uint256 private total_stored;
    IERC20 private token;


    constructor(address _token){
        token = IERC20(_token);
    }

    function storeFunds(uint256 amount) override public payable {
        require(token.allowance(address(this), msg.sender) >= amount, "Vault::Insufficient balance.");
        require(token.transferFrom(msg.sender, address(this), amount), "Vault::Transfer failed."); //emits event
        uint256 current_deposit = deposits[msg.sender];

        if(current_deposit == 0){
            wallets.push(msg.sender);
        }

        deposits[msg.sender] = amount + current_deposit;
        total_stored += amount;

        emit FundsDeposited(msg.sender, address(token), amount);
    }

    function releaseAllFunds() override public onlyOwner {
        for(uint256 i=0; i< wallets.length; i++){
            address target = wallets[i];
            (bool result, uint256 amount) = releaseFundsTo(target, deposits[target]);
            
            //transfer failed
            if(result == false){
                continue;
            }

            deposits[target] -= amount;
            total_stored -= amount;

            if(deposits[target] == 0){
                delete deposits[target];
                delete wallets[i];
            }
        }
    }

    function releaseFundsTo(address target, uint256 amount) private returns(bool, uint256) {
        require(deposits[target] >= amount, "Vault::Insufficient funds.");
        bool result = token.transfer(target, amount);

        return (result, amount);
    }

}