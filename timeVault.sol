// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;


import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract TimeVault{
uint256 public constant MinUsd =10*1e18;
// datatype visibilty specifier variableName

address[] public funders;
//No, you do not need to assign a 0 value to the array or initialize it manually.
//In Solidity, when you declare a dynamic array like address[] public funders;, it automatically starts completely empty with a length of 0.

mapping(address donaters => uint256 amntFunded) public addToAmnt;

address public immutable owner;

uint256 public immutable startTime;

// immutable se gas kam use hoti

constructor(){
    owner = msg.sender;
    startTime = block.timestamp;
}

    function fund() public payable{
require(netAmnt(msg.value)>=MinUsd,"nigga work hard,earn some real shit and then donate");
funders.push(msg.sender);
addToAmnt[msg.sender] += msg.value;
 }

 function getPrice() public view returns(uint256){
    (,int256 price, , ,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
    return uint256(price *1e10); // chainlink price feed always return the answer with 8 decimal place
 }

 // the mistake i did was not putting the view in above function always remember my function reads the data from external source and aint changing any variables so it must be put on view


 function netAmnt(uint256 EthAmnt) public view returns(uint256){
    uint256 UsdAmnt = getPrice();
    uint256 netUsdAmnt = (EthAmnt * UsdAmnt)/1e18;
    return netUsdAmnt;
 }



 function withdraw() public onlyOwner{

  

    for(uint256 i = 0 ; i<funders.length;i++){
        addToAmnt[funders[i]] = 0;
    }
    funders = new address[](0);

(bool Succ,) = payable(msg.sender).call{value:address(this).balance}("");
require(Succ,"withdraw failed");


 }

 receive() external payable{
    fund();
 }

 fallback()external payable{
    fund();
 }
// i forgot to add the external and payable..
// the reason why we use external is coz we will be calling these function outside of the contract all the time 
// payable means we can pay this contract which is what we are doing rnn




 modifier onlyOwner(){
   require(msg.sender == owner , "you aint an owner broo");
   require(block.timestamp >= startTime + 7 days,"have patience broo");
   _;
 }



}

/*
NEW LEARNING

block.timestamp always gives you the current time at the exact moment the block containing your transaction is processed.

Just remember: it doesn't give you a date format like July 17, 2026. Instead, it gives it to you as a total number of seconds (Unix time) that has passed since Jan 1 1970

So if you check it right now, it will look like a massive number (e.g., 1784289346). When a transaction runs, that massive number is what Solidity works with.

It returns a uint256 value measured in seconds, not milliseconds

Read-Only: You cannot assign a value to it (e.g., block.timestamp = 0 will throw a compiler error).


NATIVE TIME UNITS




seconds (e.g., 1 seconds = 1)

minutes (e.g., 1 minutes = 60)

hours (e.g., 1 hours = 3600)

days (e.g., 1 days = 86400)

weeks (e.g., 1 weeks = 604800)

Note: The older years suffix has been deprecated and removed because leap years change the number of seconds in a year.



*/
