---
title: Sprout Protocol Specification
---

Sprout Protocol 0.0
===

Sprout is a simple connection-oriented protocol for exchanging nodes
in the arbor forest (as defined by the [arbor forest specification](forest.md)).

Protocol requires an underlying transport that is connection-oriented and supports reliable delivery.

Sprout is an exchange of *messages*, where either side can send any message type.

*Messages* consist of a single *header line* followed by zero or more lines of *content*. All lines, both *header* and *content* end with the ASCII newline character `\n`.

There are two types of *message*, *requests* and *responses*. Any *request* will have _one or more_ responses.

All *message header lines* begin with a plaintext *verb* indicating what kind of *message* they are. 

There is no requirement to wait for a *response* before sending another *request*. Either party may choose to *respond* with an [error](#error) or [error_part](#error_part) message if the sprout implementation cannot handle a sufficient number of in-flight requests.

In *request messages*, the second whitespace-delimited element of the header line is a *message id*, which is a monotonically increasing unsigned integer (in decimal notation) that MUST be unique for the lifetime of the sprout connection. Most *messages* have different headers after the *message id*.

```
<verb> <message_id> [<header> ...]
[<content_line>]
...
```

In a *response message*, the second whitespace-delimited element of the header line is a *target message id*, which indicates which *request message* the response corresponds to. Some *request messages* will have multiple *response messages*. These are distinguished by the use of a square-bracketed *index* after the *target message id*.

```
<verb> <target_message_id>[\[<index>\]] [<header> ...]
[<content_line>]
...
```

## Message Types


### Version

The version *message* is an advertisment of the sender's protocol version. It is intended to indicate to the other end of the connection what messages are understood.

#### Possible Responses

- `ok`
- `error VERSION_TOO_HIGH`
- `error VERSION_TOO_LOW`
- `error TOO_MANY_REQUESTS`

#### Message Structure

```
version <message_id> <version number>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `version_number` should be the dotted-numeral notation of the protocol major and minor version number.

#### Example

```
version 1 0.0
```

An advertisment that the local client supports only the current unstable protocol version.

### Query Any

The `query_any` *message* requests a quantity of recent nodes of a given type. This is useful when attempting to discover new identity and community nodes.

#### Possible Responses

- `response <message_id> <count>` followed by <count> number of *response lines*
- `error TOO_MANY_REQUESTS`

#### Message Structure

```
query_any <message_id> <node_type> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_type` should one of the arbor forest node types defined [here](forest.md) as a decimal integer.
- `quantity` should be the number of nodes requested. The response is guaranteed to have less than or equal to this many elements.

#### Example

```
query_any 5 1 10
```

A request for ten community nodes.

### Query 

The `query` *message* requests a list of specific nodes. This is useful when looking up specific node values (like when resolving the authors of reply nodes).

#### Possible Responses

- `response <message_id> <count>` followed by <count> number of *response lines*
- `error TOO_MANY_REQUESTS`

#### Message Structure

```
query <message_id> <count>
<node_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *message ids* that follow the header row (one per line).

#### Example

```
query_any 27 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Ancestry

The `ancestry` *message* requests the nodes prior to a list of nodes within the arbor forest up to a specified depth. This is useful when looking up the history of a collection of leaf nodes.

#### Possible Responses

- Multiple of `response <message_id>[index] <count>` followed by <count> number of *response lines*
- `error TOO_MANY_REQUESTS`

#### Message Structure

```
ancestry <message_id> <count>
<ancestry_request>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *ancestry request lines* that follow the header row (one per line).
- `ancestry_request` lines are structured as:
  - `<num_levels> <node_id>` where `num_levels` is the maximum number of ancestor nodes requested, and `node_id` is the ID of the forest node to start backtracking from.

#### Example

```
ancestry 44 3
4 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
23 SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
7 SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

A request for ancestry of each of the three listed nodes. Note that the number of ancestry nodes requested varies between the three. Each of these three ancestries will generate a separate response or error message.

```
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
