"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var protobufjs_1 = require("protobufjs");
var protoJSON = require('./messages.json');
function loadProtocolBuffers() {
    if (typeof window !== 'undefined') {
        return Promise.resolve(protobufjs_1.Root.fromJSON(protoJSON));
    }
    return protobufjs_1.load(__dirname + "/../proto/messages.proto");
}
exports.default = loadProtocolBuffers;
