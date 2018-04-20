"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var protobufjs_1 = require("protobufjs");
var protoJSON = require('./messages.json');
var loadProtocolBuffers = function () { return protobufjs_1.Root.fromJSON(protoJSON); };
exports.default = loadProtocolBuffers;
