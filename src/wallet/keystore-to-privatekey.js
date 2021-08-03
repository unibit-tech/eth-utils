const keyeth = require("keythereum")

const fileLocation = process.argv[2];
const pwd = process.argv[3];
const keyObj = keyeth.importFromFile("0xe0bc5248a755626110d59e4f51772ff224702387", fileLocation);

console.log("Private key: ", keyeth.recover(pwd, keyObj).toString("hex"));