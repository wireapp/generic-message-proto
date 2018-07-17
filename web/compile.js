const fs = require('fs');
const path = require('path');
const {pbjs, pbts} = require('protobufjs/cli');

const dtsOutput = path.join(__dirname, 'Protobuf.d.ts');
const jsOutput = path.join(__dirname, 'Protobuf.js');
const protoBufferFile = path.join(__dirname, '..', 'proto', 'messages.proto');

pbjs.main(['--target', 'static-module', '--wrap', 'commonjs', protoBufferFile], (error, output) => {
  if (error) {
    throw error;
  }
  fs.writeFileSync(jsOutput, output, {encoding: 'utf8'});
  pbts.main(['--out', dtsOutput, '--no-comments', jsOutput]);
});
