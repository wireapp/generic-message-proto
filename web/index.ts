import { load, Root } from 'protobufjs';

function loadProtocolBuffers(): Promise<Root> {
  return load(`${__dirname}/../proto/messages.proto`);
}

export = loadProtocolBuffers;
