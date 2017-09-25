import {load, Root} from 'protobufjs';

export default function (): Promise<Root> {
    return load('../proto/messages.proto');
}