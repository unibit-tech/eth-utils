const ethers = require('ethers');

const mnemonic = process.argv[2];
console.log("generating private key for ", mnemonic)
const mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);

console.log("Private key:", mnemonicWallet.privateKey);
console.log("Public key:", mnemonicWallet.publicKey);
console.log("Address:", mnemonicWallet.address);