# TEMPORARY – remove before merging

Working notes for adding `GenericMessage.client_created_at_millis` (field 33).
Move anything that should outlive this branch into an RFC / Confluence page.

## Goal

Show recipients that a message was *written* significantly earlier than it was
*delivered* (e.g. composed offline, sent from the offline queue once the
connection came back).

## Why a protocol change is needed

`GenericMessage` previously had no sender-side timestamp. The time clients show
is the backend event time, i.e. when the server accepted the message. A
recipient cannot detect a delayed send, so the sender must include the time in
the (E2E-encrypted) payload.

## Decisions

- **Placement:** top level of `GenericMessage`, outside the `oneof` (like
  `unknownStrategy`). That way it covers every content type (Text, Asset,
  Multipart, Composite, Ephemeral, MessageEdit, …) and works the same for
  Proteus and MLS.
- **Name:** `client_created_at_millis`: snake_case with a `_millis` suffix,
  consistent with `expire_after_millis` and `last_read_timestamp`.
- **Type:** `optional int64`, milliseconds since Unix epoch (UTC). No
  `google.protobuf.Timestamp` (no well-known-type imports, `LITE_RUNTIME`).
- **Field number:** 33. Numbers are shared between the `oneof` and the
  enclosing message: 25 = unknownStrategy, 26 = inCallHandRaise,
  27 = multipart, 28–32 = history client / poll messages that Android
  (Kalium) already ships (PR #108). Originally 28; moved to 33 after the
  clash with #108. Before allocating numbers, check Kalium's own proto copy
  (`wireapp/kalium` → `tools/protobuf-codegen/src/main/proto/messages.proto`),
  which can be ahead of this repo. "Next field" comment now says 34.
- **Backward compatibility:** optional proto2 field, so old clients skip it
  silently. No `UnknownStrategy` implications.

## Semantics (must be agreed by all clients)

- Value = the moment the user triggered "send" (not when they started typing).
- Sender SHOULD correct by its known offset to server time (verify which
  clients already track such an offset) to reduce clock-skew noise.
- MUST stay unchanged across retries, the offline queue and re-encryption
  (Proteus missing-client resend, MLS epoch change retry). Regenerating it on
  retry would silently break the feature.
- `External` messages: set it on the **inner** encrypted GenericMessage.
- `MessageEdit`: the edit is its own GenericMessage and carries its own value.
  Open: should the UI ever show "edited earlier" hints?

## Trust model / risks

- **The value is asserted by the sender, not verified.** E2E guarantees *who*
  sent it, not that it's true. A modified client can backdate messages
  ("written before the deadline"), and a wrong device clock produces bogus
  values.
- Therefore: **informational only.** Never use it for ordering, unread state,
  ephemeral expiry, retention or legal hold. Server time remains authoritative.
- Receivers SHOULD ignore values later than the server timestamp (future/skew)
  and only show a hint above a generous threshold (minutes, not seconds).
- Minor privacy aspect: reveals to recipients roughly when the sender was
  offline. The backend can't see it (encrypted payload).

## Alternatives considered

- **UUIDv7 `message_id`** (embeds a timestamp): rejected. Existing IDs are v4,
  it overloads an identifier with meaning, and "absent" can't be distinguished
  from "old client".
- **Per-content-type field** (on Text, Asset, …): rejected. Repetitive and
  easy to forget for future content types.

## Open questions / TODO

- [ ] Display threshold and UX copy (product/design).
- [ ] Confirm each client (web, Android, iOS) actually has an offline send
      queue whose delays make this worthwhile.
- [ ] Decide whether to set the field on all message types or only on
      user-visible content (cheap to always set; receivers just ignore it
      where irrelevant).
- [ ] Run `yarn dist && yarn test` (not run while drafting: no node toolchain
      on that machine) and check the Android/iOS builds.
- [ ] This branch currently contains PR #108 (merged from
      `feat/protocol-update-from-android`, not yet on master). Once #108 lands
      on master, merge master in again and confirm the numbers 28–32 haven't
      changed. If #108 is squash-merged, expect conflicts on its lines.
- [ ] Remove this file before merging.
