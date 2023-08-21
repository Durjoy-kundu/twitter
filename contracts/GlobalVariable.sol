
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract Tweeter{
    address public functionCaller;
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    function random() public{
        functionCaller = msg.sender;
    }
    function currentBlockTime() public view returns(uint){ // global variable considers as state variable
        return block.timestamp; //return unix time
    }
    uint public a = 5;
    string public str = "Hello world";
    function deleteA() public{
        delete str;
    }
}