---
title: Sprout Protocol 0.0 Specification
---

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

#### Message Structure

```
version <message_id> <version number>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `version_number` should be the dotted-numeral notation of the protocol major and minor version number.

#### Possible Responses

- `ok_part`
- `error`

#### Example

```
version 1 0.0
```

An advertisment that the local client supports only the current unstable protocol version.

### Query Any

The `query_any` *message* requests a quantity of recent nodes of a given type. This is useful when attempting to discover new identity and community nodes.

#### Message Structure

```
query_any <message_id> <node_type> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_type` should one of the arbor forest node types defined [here](forest.md) as a decimal integer.
- `quantity` should be the number of nodes requested. The response is guaranteed to have less than or equal to this many elements.

#### Possible Responses

- `response`
- `error`

#### Example

```
query_any 5 1 10
```

A request for ten community nodes.

### Query 

The `query` *message* requests a list of specific nodes. This is useful when looking up specific node values (like when resolving the authors of reply nodes).

#### Message Structure

```
query <message_id> <count>
<node_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *node ids* that follow the header row (one per line).

#### Possible Responses

- `response`
- `error`

#### Example

```
query_any 27 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Ancestry

The `ancestry` *message* requests the nodes prior to a list of nodes within the arbor forest up to a specified depth. This is useful when looking up the history of a collection of leaf nodes.

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

#### Possible Responses

- Multiple `response`
- `error`

#### Example

```
ancestry 44 3
4 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
23 SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
7 SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

A request for ancestry of each of the three listed nodes. Note that the number of ancestry nodes requested varies between the three. Each of these three ancestries will generate a separate response or error message.

### Leaves Of

The `leaves_of` *message* requests the a quantity of recent leaf nodes in the subtree rooted at a specific node. This is useful for discovering recent conversations when you join a relay.

#### Possible Responses

- `response`
- `error`

#### Message Structure

```
leaves_of <message_id> <node_id> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_id` should be the base64url-encoded identifier of the arbor node whose leaf descendants you are querying for.
- `quantity` should be the number of nodes requested. The response is guaranteed to have less than or equal to this many elements.

#### Example

```
leaves_of 101 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk 45
```

A request for the 45 most recent leaf nodes of the given node.

### Response

The `response` *message* contains a set of results for part (or all) of a previous request message.

#### Message Structure

```
response <target_message_id>[<index>] <count>
<node_id> <node_content>
...
```

- `target_message_id` is the message id of the request message that this responds to.
- `index` is the request part index (0-based) that this is a response to. For instance, an `ancestry` request can ask for the histories of many different nodes. A response for the second of those nodes would have an `index` of `1`.
- `count` should be the number of *node lines* that follow the header row (one per line).
- `node` lines are structured as:
  - `<node_id> <node_content>` where `node_id` is the ID of the forest node on the line and `node_content` is the base64url-encoded content of the node.

#### Example

```
response 44[2] 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk YNAPcdvwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5Fejek...
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM vwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5FekDNITsfYF...
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co 5Fe4EkkwkDNITsfYFFsTu95jM5Fe5Fe4EkkwkDNITsfYFFsTu95jM5Fe...
```

A response for the third part of request `44` containing three nodes.

### Subscribe

The `subscribe` *message* requests that updates to a list of community nodes be shared over the current connection in real time. This goes both directions. If a subscribe is accepted, both sides agree to share new nodes within that community as soon as they are discovered (by any means). The `subscribe` message is a multiple-response message. Each requested community node can be individually accepted or rejected by the other side of the connection.

#### Message Structure

```
subscribe <message_id> <count>
<community_id>
<community_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *community ids* that follow the header row (one per line).

#### Possible Responses

- `ok_part`
- `error_part`

#### Example

```
subscribe 20 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Unsubscribe

The `unsubscribe` *message* requests that updates to a list of community nodes no longer be shared over the current connection. This goes both directions. `unsubscribe` messages MUST be honored by both sides, but the request may error if attempting to unsubscribe from a non-subscribed or nonexistent community. The `unsubscribe` message is a multiple-response message.

#### Message Structure

```
unsubscribe <message_id> <count>
<community_id>
<community_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *community ids* that follow the header row (one per line).

#### Possible Responses

- `ok_part`
- `error_part`

#### Example

```
unsubscribe 110 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Error

The `error` *message* indicates that previous request failed.

#### Message Structure

```
error <target_message_id> <error_code>
```

- `target_message_id` is the message id of the request message that this responds to.
- `error_code` is one of the codes listed in [Error Codes](#error-codes).

#### Example

```
error 44 3
```

This message indicates that the request with `message_id` 44 referred to a node that is unknown to the other end of the connection.

### Error Part

The `error_part` *message* indicates that part of a previous request failed.

#### Message Structure

```
error_part <target_message_id>[<index>] <error_code>
```

- `target_message_id` is the message id of the request message that this responds to.
- `index` is the request part index (0-based) that this is a response to. For instance, an `ancestry` request can ask for the histories of many different nodes. A response for the second of those nodes would have an `index` of `1`.
- `error_code` is one of the codes listed in [Error Codes](#error-codes).

#### Example

```
error_part 48[2] 3
```

This message indicates that the third item requested by the message with `message_id` 48 referred to a node that is unknown to the other end of the connection.

### Ok Part

The `ok_part` *message* indicates that part of a previous request succeeded.

#### Message Structure

```
ok_part <target_message_id>[<index>]
```

- `target_message_id` is the message id of the request message that this responds to.
- `index` is the request part index (0-based) that this is a response to. For instance, an `ancestry` request can ask for the histories of many different nodes. A response for the second of those nodes would have an `index` of `1`.

#### Example

```
ok_part 201[0]
```

This message indicates that the first item requested by the message with `message_id` 201 succeeded.

### Announce

The `announce` *message* contains a set of new nodes belonging to one of the connection's subscribed communities. This message is used to inform the other end of the connection of new content.

#### Message Structure

```
announce <message_id> <count>
<node_id> <node_content>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *node lines* that follow the header row (one per line).
- `node` lines are structured as:
  - `<node_id> <node_content>` where `node_id` is the ID of the forest node on the line and `node_content` is the base64url-encoded content of the node.

#### Example

```
announce 321 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk YNAPcdvwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5Fejek...
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM vwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5FekDNITsfYF...
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co 5Fe4EkkwkDNITsfYFFsTu95jM5Fe5Fe4EkkwkDNITsfYFFsTu95jM5Fe...
```

Three new nodes from a subscribed community being announced to the other end of the connection.

## Error Codes

<table class="table table-sm table-hover">
  <thead>
    <tr>
      <th>Numeric Value</th>
      <th>Human Name</th>
      <th>Meaning</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>
        0
        </td>
        <td>
        Malformed
        </td>
        <td>
        the request was not structurally valid in this protocol version
        </td>
    </tr>
    
    <tr>
        <td>
        1
        </td>
        <td>
        Protocol Too Old
        </td>
        <td>
        the requested protocol version is too old
        </td>
    </tr>
    
    <tr>
        <td>
        2
        </td>
        <td>
        Protocol Too New
        </td>
        <td>
        the requested protocol version is too new
        </td>
    </tr>
    
    <tr>
        <td>
        3
        </td>
        <td>
        Unknown Node
        </td>
        <td>
        the request refers to a forest node that is not known
        </td>
    </tr>
  </tbody>
</table>

## Procedure:

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
