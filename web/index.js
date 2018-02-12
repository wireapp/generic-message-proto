"use strict";
var protobufjs_1 = require("protobufjs");
function loadProtocolBuffers() {
    return protobufjs_1.load(__dirname + "/../proto/messages.proto");
}
module.exports = loadProtocolBuffers;
