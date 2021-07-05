pragma solidity ^0.4.11;

contract Multigift {
    address public _owner;
    uint public _interval;
    Gift[] public _gifts;

    struct Gift {
      address addr;
      uint value;
      uint time;
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


    function Multigift(uint interval) public {
        _owner = msg.sender;
        _interval = interval;
    }

    function buildGift() payable
                        public
                        isntOwner(_owner)
    {
      var (index, exist) = getGiftIndex(msg.sender);
      if(!exist) {
        _gifts[index].value += msg.value;
      } else {
        _gifts[_gifts.length] = Gift({
                                  addr: msg.sender,
                                  value: msg.value,
                                  time: now
                                });
      }
    }

    function valid() public
                    isOwner(_owner)
    {
        uint[] memory toRemove;

        for (uint i = 0; i < _gifts.length && i < 50; i++) {
          if(now > _gifts[i].time + _interval) {
            uint value = _gifts[i].value;
            _gifts[i].value = 0;
            _owner.transfer(value);

            toRemove[toRemove.length] = i;
          }
        }

        for (uint x = 0; x < toRemove.length && x < 50; x++) {
          delete _gifts[toRemove[x]];
        }
    }

    function cancel() public
                      isntOwner(_owner)
    {
        var (index, exist) = getGiftIndex(msg.sender);
        if(exist) {
          uint value = _gifts[index].value;
          _gifts[index].value = 0;
          _gifts[index].addr.transfer(value);

          delete _gifts[index];
        }
    }

    function getGiftIndex(address ad) private returns(uint, bool)
    {

        if(_gifts.length == 0) {
          return (0, false);
        }

        for (uint i = 0; i < _gifts.length && i < 50; i++) {
          if(ad == _gifts[i].addr) {
            return (i, true);
          }
        }

        return (0, false);
    }
}
