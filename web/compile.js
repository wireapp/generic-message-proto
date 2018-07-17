/*
 * Wire
 * Copyright (C) 2018 Wire Swiss GmbH
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 *
 */

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
