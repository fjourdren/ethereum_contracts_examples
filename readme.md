Start a local ethereum blockchain:
```
cd ethereum/go-ethereum/build/bin
./geth --dev --port 1250 --maxpeers 0 --datadir "data"
./geth --dev attach ipc:data/geth.ipc

personal.newAccount('choose-a-password')
miner.start()
personal.newAccount('choose-a-password')


ethereumwallet --rpc /home/flavien/ethereum/go-ethereum/build/bin/data/geth.ipc

miner.stop()
```