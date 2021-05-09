# eth-utils
Local stack for operations on an Ethereum blockchain 

## Usages
1. Deploy a local Ethereum blockchain
2. Deploy contracts
3. Mine Ethereum nodes
4. Call deployed contracts with test data

### Requirements
* docker
* go

### How to start the project
1. export two new vars in either `.zshrc` or `.bashrc` depending on your preferred
shell
   1. `export GOPATH="/$HOME/workspace/"` (depending on your preferred workspace, change `workspace` 
      with your project's root folder)
   1. `export PATH=./scripts/:./:./tools/:$GOPATH/bin:$PATH`
1. run `start` in the project root to start the local ethereum stack (2 nodes from which one is mining)
1. running start will also deploy usdt and usdc contract in the blockchain
