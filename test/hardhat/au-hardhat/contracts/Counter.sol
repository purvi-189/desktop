// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter{
    uint public count;

    //get current count
    function get() public view returns(uint){
        return count;
    }

    //inc count by 1
    function inc() public{
        count+=1;
    }

    //dec count by 1
    function dec() public{
        count-=1;
    }
}   