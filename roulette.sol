pragma solidity ^0.4.11;

//Roulette 14 cases
//0 multiply per 10
//others good bets multiply per 1.75

contract Roulette {
    address public _owner;
    uint public _timestampLastRun;
    uint public _interval;

    Bet[] _bets;

    struct Bet {
      address addr;
      uint value;
      uint numberBet;
    }


    modifier isOwner(address owner)
    {
        require(msg.sender == owner);
        _;
    }

    modifier canBeRun(uint timestampLastRun, uint interval)
    {
        require(now > _timestampLastRun + _interval);
        _;
    }


    function Roulette(uint intervalVal)
    {
        _owner = msg.sender;
        _timestampLastRun = now;
        _interval = intervalVal;
    }

    function newBet(uint numberBet) public payable
    {
        _bets.push(Bet({
          addr: msg.sender,
          value: msg.value,
          numberBet: numberBet
        }));
    }

    function run() public canBeRun(_timestampLastRun, _interval)
    {
        uint result = uint(block.blockhash(block.number - 1)) % 15;

        for (uint i = 0; i < _bets.length; i++) {

          if(_bets[i].numberBet == result) {
              _bets[i].addr.transfer(getPayout(result, _bets[i].numberBet));
          }

        }

        clearBets(); //clear bets

        _timestampLastRun = now;

    }

    function getPayout(uint number, uint betValue) private returns(uint)
    {
        if(number == 0) {
          return betValue * 10;
        } else {
          return betValue * 5 / 4;
        }
    }

    function clearBets() private
                        canBeRun(_timestampLastRun, _interval)
    {
      for (uint i = 0; i < _bets.length; i++) {
        delete _bets[i];
      }
    }

    function withdrawOwner(uint value) public
                                      isOwner(_owner)
    {
      _owner.transfer(value);
    }
}
