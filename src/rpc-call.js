const rpc = require('node-json-rpc');

const options = {
  port: 80,
  host: 'https://rinkeby.infura.io/v3/feb8c69ad6b1444a8f2ebcd2fbb91ef1',
  path: '/',
  strict: true
};

const client = new rpc.Client(options);

//validateaddress call
client.call(
  {"jsonrpc": "2.0", "method": "getTransactionHash",
    "params": ['0xad09dee1Af39bEBb67bCf26E7826Df2D9acEBbF7'], "id": 0}, function(err, res){
    if(err) {
      console.log(err);
    } else {
      console.log(res);
    }
  });