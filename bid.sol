pragma solidity ^0.4.11;

contract Bid {

    address public _owner;
    address public _lastBidder;
    uint public _startValue;
    uint public _value;
    uint public _finishTimestamp;

    modifier timeIsFinish(uint finishTimestamp)
    {
        require(now >= _finishTimestamp);
        _;
    }

    modifier isOwner(address owner)
    {
        require(msg.sender == owner);
        _;
    }

    modifier isntOwner(address owner)
    {
        require(msg.sender != owner);
        _;
    }


    function Bid(uint startValue, uint finishInterval) payable
    {
        _owner = msg.sender;
        _startValue = startValue;
        _value = 0;
        _finishTimestamp = now + finishInterval;
    }

    function makeOffer() public payable
                        isntOwner(_owner)
    {
        if(msg.value > _value && msg.value > _startValue) {

          if(_value > 0) {
            uint oldValue = _value;
            _value = 0;
            _lastBidder.transfer(oldValue);
          }

          _lastBidder = msg.sender;
          _value = msg.value;
        } else {
          msg.sender.transfer(msg.value);
        }
    }

    function finishBid() public
                        isOwner(_owner)
                        timeIsFinish(_finishTimestamp)
    {
        suicide(_owner);
    }

    function cancelBid() public
                        isOwner(_owner)
    {
        suicide(_lastBidder);
    }
}
