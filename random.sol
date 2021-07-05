pragma solidity ^0.4.11;

contract Random {
    uint public _result;


    function Random() {

    }

    function run() public
    {
      _result = uint(block.blockhash(block.number - 1)) % 37;
    }
}
