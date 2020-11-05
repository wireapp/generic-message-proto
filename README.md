# Wire

This repository is part of the source code of Wire. You can find more information at [wire.com](https://wire.com) or by contacting opensource@wire.com.

You can find the published source code at [github.com/wireapp/wire](https://github.com/wireapp/wire).

For licensing information, see the attached LICENSE file and the list of third-party licenses at [wire.com/legal/licenses/](https://wire.com/legal/licenses/).

# GenericMessage protocol
Protocol definition for generic messages.

`GenericMessage` is supposed to be used in client messages ('client-message-add' event) and in OTR encrypted messages. Once E2EE is released client messages will no longer be used.

`GenericMessage` contains message id and specific message content (`oneOf`)

## Message Id
`MessageId` field is client generated identifier of a message this `GenericMessage` relates to, it should be used by all clients to correlate message updates. This is **not** unique event id, there may (and will) be several `GenericMessage` events with the same `messageId`, each `GenericMessage` provides part of final message or some update to it.

Each ImageAsset version/tag is sent in separate request which means there are several `GenericMessage` events for each asset, all of them will use the same `messageId`, this actually replaces `correlationId` from regular asset events. It will be the same for different updates, for example *like* events, they will all contain `messageId` of references message.

### Id collisions
Clients need to take case of message id collisions. It is possible, that some malicious client will generate events with the same id in order to override other messages. Every time `GenericMessage` is received, client need to check if it already has a message with the same id and make sure that this is a valid update. If received event is not valid update (for example sender doesn't match to original message author in text messages), then clients is allowed to drop the message or use different id for it. Using different id is preferred to handle unintended collisions or to expose buggy sender behaviour.

## Message Content
Actual message content is included as `oneof` field in `GenericMessage`, this way we can later add more message types in backward compatible manner.

### Availability
A user sends a generic message of type `Availability` if he wants to change his personal availability. The availability can be of four types: `None`, `Available`, `Busy`, and `Away`.

### Text
Regular text message content, optionally including a list of mentioned users.

#### Mention
Describes user mentioned in text message. Contains `user_id`, `start` and `end` offsets of the mention string in UTF16 characters. The offset is used to highlight mention text inside the message. `user_id` is optional because to keep it backwards compatible when mentioning more than one user e.g. @everyone or @some_team. 

### Knock

### LastRead
Internal message, sent on self conversation to notify other clients (belonging to the same user) about messages being read in some conversation.

### Cleared
Internal message, sent on self conversation to notify other clients about conversation being cleared.

### MessageHide
Internal message, sent on self conversation to notify other clients about message being locally deleted.

### MessageDelete
Message sent to recall previously sent message, can be only sent by original author of deleted message.

### MessageEdit
If the content of a previously sent message should be edited, a generic message of type `MessageEdit` has to be sent.
It should reference the new content (for now only type `Text` can be edited) as well as the nonce of the message it is replacing. If an edit message is received which is referencing a non existent nonce it should be discarded.

### Confirmation
If the reception of a previously sent message should be confirmed, a generic message of type `Confirmation` has to be sent. It should reference the message to be confirmed. Currently the confirmation comes in two flavours: `Read` and `Delivered`.

### Location
Location sharing message, contains GPS coordinates (latitude and longitude) and optional location name string.

### Reaction
Expresses a reaction to a previously received message. The reaction itself can be any string but should be an emoji. If there are multiple reactions from one user to the same message, only the most recent one should be kept. In order to remove/clear a previous reaction, the empty string should be sent.

### ImageAsset
Contains metadata for single image asset version, most fields correspond to metadata sent on regular assets endpoint.
There are three special fields:

- `otr_key` - optional symmetric encryption key. If asset message includes this key, then asset stored on backend is encrypted, and clients can use this key to decrypt original image data.
- `sha256` - hash of encrypted asset ciphertext. Should be provided for encrypted messages, clients should check it before trying to decrypt an asset.

Asset encryption should follow similar procedure as symmetric encryption in native push notifications.
Encryption with standard AES256 in CBC mode with PKCS#5/7 padding and the initialization vector (IV) prepended to the ciphertext.
SHA256 is computed from cyphertext, receiving client validates it before decrypting an asset.

### Asset
Metadata for generic file uploads. Intended to supersede ImageAsset at a later point. For encryption and related fields, see ImageAsset.

This message can be received in up to 3 parts which then can be merged together to build a complete asset record.

- Upload is starting: the field `original` is set with basic info about the file being uploaded.
- Preview has been uploaded: the field `preview` is set with basic info about the preview as well as the encryption fields. This step is optional.
- One of two messages arrive next:
  + File upload is cancelled or has failed, in which case the `status.not_uploaded` field is set with the appropriate value.
  + File upload has completed successfully. The `status.uploaded` field is set with encryption info provided.

### External
This message content is used if original message results in large payload, that would not be accepted by backend.
Regular messages are encrypted multiple times (per recipient) and in case of multiple participants even quite small
message can generate huge payload.
In that case we want to encrypt original message with symmetric encryption and only send a key to all participants.

Clients use fallowing procedure when sending a message:

- generate original `GenericMessage` (`OM`)
- estimate payload size - client could run regular encryption step and check the size of encrypted data, or could estimate the size based on participants count (make sure to recheck if new participant is added after `ClientMismatch` error)
- if payload is smaller than 256KB then `OM` can be sent directly
- if payload is too big:
  - encrypt `OM` using symmetric encryption (the same way as for assets)
  - create `External` message with AES key and sha of encrypted data
  - send message with `External` content and encrypted `OM` attached (`data` field in json)

## Forward compatibility
Messages sent through OTR can be decrypted only once, so it's important not to loose any info, even when receiving a message that can not be fully decoded (when using older app version). It would be advisable to save original `GenericMessage` data and decode it again after app update. This should be done at least when decoded message seems to have no `content`, this will happen when new content type is added, in that case old app will think that the message is empty.
