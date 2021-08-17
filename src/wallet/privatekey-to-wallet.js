const ethers = require('ethers');

const pk = process.argv[2];
const wallet = new ethers.Wallet(pk);

console.log("Private key:", wallet.privateKey);
console.log("Public key:", wallet.publicKey);
console.log("Address:", wallet.address);