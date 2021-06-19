# eth-utils
Local stack for operations on an Ethereum blockchain 

## Usages
1. Deploy a local Ethereum blockchain
2. Deploy contracts
3. Mine Ethereum nodes
4. Call deployed contracts with test data
5. Init an account and get the private / public key from mnemonic

### Requirements
* docker
* go

### How to start the project
1. export two new vars in either `.zshrc` or `.bashrc` depending on your preferred
shell
   1. `export GOPATH=\"/$HOME/workspace/\"` (depending on your preferred workspace, change `workspace` 
      with your project's root folder)
   1. `export PATH=./scripts/:./:./tools/:$GOPATH/bin:$PATH`
1. run `start` in the project root to start the local ethereum stack (2 nodes from which one is mining)
1. running start will also deploy usdt and usdc contract in the blockchain
1. run `stop` to destroy the docker containers, network

### How to deploy a smart contract
1. place the smartcontract inside `eth-utils/contracts`
   1. we use as example `SafeMath.sol`
1. inside the project root, run `deploy-contract.sh SafeMath` (notice we are not passing .sol file type)
1. if the contract compiles, it will be deployed, you should notice a new tx created in the blockchain
and Docker should return an output similar to the SafeMath output:
```
{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":null}
waiting for the transaction hash (0xb897cd4200c80a5d85bb2c5c1539d296bc4b8fc261ee341e0652b58921a2810c) to be available...
{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":{\"blockHash\":\"0x80d200c90bd1fc537396acf9cd570412738f0ef609b849fa600004fec0954ef6\",
\"blockNumber\":\"0x46a\",\"contractAddress\":\"0x4a2dbb178b10d38e7e6eb2f897ad5bd41b2978ee\",\"cumulativeGasUsed\":\"0x12b6e\",
\"from\":\"0xe022cfd8c97a67c298729200e1ee3381e8f16547\",\"gasUsed\":\"0x12b6e\",\"logs\":[],
\"logsBloom\":\"0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000\",\"status\":\"0x1\",\"to\":null,\"transactionHash\":\"0xb897cd4200c80a5d85bb2c5c1539d296bc4b8fc261ee341e0652b58921a2810c\",\"transactionIndex\":\"0x0\",\"type\":\"0x0\"}}
Contract address is: 0x4a2dbb178b10d38e7e6eb2f897ad5bd41b2978ee
Saving contract address to /root/contracts/SafeMath/SafeMath-address.txt
```


{\"safe\": \"0xad09dee1Af39bEBb67bCf26E7826Df2D9acEBbF7\",\"to\": \"0x970119d7A55934D628D1766aEC7CF87716Ce17E9\",\"value\": 1000000000000000000,\"operation\": 0,\"data\": null,\"safeTxGas\": 43845,\"gasToken\": null,\"baseGas\": 0,\"gasPrice\": 0,\"refundReceiver\": null,\"nonce\": 2,\"contractTransactionHash\": \"0x45f24f934ebb77afb37baeb132fe84f0c4dc0fbc2cf0e480f9d190581e958cd4\",\"sender\": \"0xdE1220f39C46c327Fc5112846A75F3E05d42B48a\",\"origin\": \"Tx Service Tutorial\"}