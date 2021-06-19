const ethers = require('ethers');

let mnemonic = process.argv[2];
console.log("generating private key for ", mnemonic)
let mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);

console.log("Private key:", mnemonicWallet.privateKey);
console.log("Public key:", mnemonicWallet.publicKey);