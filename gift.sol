pragma solidity ^0.4.11;

contract Gift {
    uint public _value;
    uint public _endFreezeTransactionTimestamp;
    address public _sender;
    address public _receiver;

    function Gift(address receiver, uint intervalInDay) payable {
      _value = msg.value;
      _endFreezeTransactionTimestamp = now + intervalInDay * 3 * 24 * 60 * 60;
      _sender = msg.sender;
      _receiver = receiver;
    }

    function valid() public {
        if(msg.sender != _receiver) revert();
        if(now < _endFreezeTransactionTimestamp) revert();

        suicide(_receiver);
    }

    function cancel() public {
        if(msg.sender != _sender) revert();
        if(now > _endFreezeTransactionTimestamp) revert();

        suicide(_sender);
    }
}
