const ethers = require('ethers');

const mnemonic = process.argv[2];
const messageToSign = ethers.utils.hexValue(process.argv[3]);
console.log("generating wallet from ", mnemonic)
const mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);

console.log("Private key:", mnemonicWallet.privateKey);
console.log("Public key:", mnemonicWallet.publicKey);
console.log("Address:", mnemonicWallet.address);

mnemonicWallet.signMessage(ethers.utils.arrayify(messageToSign)).then(
  (res) => {
    console.log("signed message: ", res);
    const recoveredAddress = ethers.utils.verifyMessage(ethers.utils.arrayify(messageToSign), res);
    const pk = ethers.utils.recoverPublicKey(
      ethers.utils.arrayify(ethers.utils.hashMessage(ethers.utils.arrayify(messageToSign))),
      res
    );

    console.log("Signing address: ", recoveredAddress);
    console.log("Signing public key: ", pk);
  }
);
