// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "../../interfaces/IVault.sol";

contract Vault is IVault, Ownable, Pausable {

    mapping(address => uint256) public deposits;
    address[] private wallets;
    uint256 private total_stored;
    IERC20 private token;


    constructor(address _token){
        token = IERC20(_token);
    }

    function storeFunds(
        address payable sender, 
        uint256 amount
        ) override public payable whenNotPaused {
        require(token.allowance(address(this), sender) >= amount, "Vault::Insufficient balance.");
        require(token.transferFrom(sender, address(this), amount), "Vault::Transfer failed."); //emits event
        uint256 current_deposit = deposits[sender];

        //store new wallets
        if(current_deposit == 0){
            wallets.push(sender);
        }

        deposits[sender] = amount + current_deposit;
        total_stored += amount;

        emit FundsDeposited(sender, address(token), amount);
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

            emit FundsReleased(target, address(token), amount);
        }
    }

    function releaseFundsTo(address target, uint256 amount) private returns(bool, uint256) {
        require(deposits[target] >= amount, "Vault::Insufficient funds.");
        bool result = token.transfer(target, amount);

        return (result, amount);
    }

    function getAcceptedToken() override public view returns(address){
        return address(token);
    }

}