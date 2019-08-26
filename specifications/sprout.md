---
title: Sprout Protocol Specification
---

Sprout Protocol 0.0
===

Protocol requires transport that is:
- connection-based
- reliable delivery

Protocol messages:
- newline delimited messages
- first line is header information and includes length of subsequent lines

Example:
```
response message_id:2 count:5
SHA512...
SHA512...
SHA512...
SHA512...
SHA512...
```

Anatomy of protocol message:
```
<verb> <id> [message-specific fields]
```

Messages:
```
version <message_id> <version number>

query_any <message_id> <node-type> <quantity>

query <message_id> <count>
<node_id>
[<node_id>...]

ancestry <message_id> <count>
<num> <node_id>
[<num> <node_id>...]

leaves_of <message_id> <node_id> <quantity>

response <target_message_id>[<index>] <count>
<node_id> <node>
[<node_id> <node>...]

subscribe <message_id> <count>
<community_id>
[<community_id>...]

unsubscribe <message_id> <count>
<community_id>
[<community_id>...]

error <target_message_id> <error_code>

error_part <target_message_id>[<index>] <error_code>

ok_part <target_message_id>[<index>]

announce <message_id> <count>
<node_id> <node>
[<node_id> <node>...]
```

Procedure:
```
client -> server: version
server -> client: version | error (unsupported)

client -> server: query_any communities
server -> client: response (of communities) | error

client -> server: unsubscribe | subscribe (to communities)
server -> client: ok_part | error_part

peer1 -> peer2: announce

peer1 -> peer2: query_any | leaves_of
peer2 -> peer1: response | error

peer1-> peer2: query N | ancestry N
peer2 -> peer1: response N[0] | error_part
peer2 -> peer1: response N[1] | error_part

...
```

Encoding:

- node ids are their base64url versions (produced by MarshalText)
- ndoes are their base64url encoded binary format (produced by MarshalBinary
