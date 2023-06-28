// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;
contract Token{
    string public name = "Hardhat Token";
    string public symbol = "HHT";
    uint public totalSupply = 10000;
    address public owner;
    mapping(address=>uint) balances;
    
    constructor(){
        balances[msg.sender]=totalSupply;
        owner= msg.sender;
    }
    function transfer(address to , uint amount) external{
        require(balances[msg.sender]>=amount,"Not enought tokens");
        balances[msg.sender]-=amount;
       balances[to]+=amount;
       
    }

    function balanceOf(address account) external view returns(uint256){
        return balances[account];
    }
}





