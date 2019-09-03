---
title: Sprout Protocol 0.0 Specification
---

Sprout is a simple connection-oriented protocol for exchanging nodes
in the arbor forest (as defined by the [arbor forest specification](forest.md)).

Protocol requires an underlying transport that is connection-oriented and supports reliable delivery.

Sprout is an exchange of *messages*, where either side can send any message type.

## Message Structure

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

## Content Line Types

Sprout messages that have a body of extra data after their header lines use one of several structures for each line of their body:

### Node ID Lines

A *node_id_line* just contains a base64url-encoded Node ID for an Arbor Forest node.

```
<node_id>
```

### Counted Node ID Lines

A *counted_node_id_line* contains an unsigned integer and an Arbor Forest Node ID.

```
<int> <node_id>
```

### Full Node Lines

A *full_node_line* contains an Arbor Forest Node ID followed by the base64url-encoded value of that entire Arbor Forest Node.

```
<node_id> <node>
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

- `status`

#### Example

```
version 1 0.0
```

An advertisment that the local client supports only the current unstable protocol version.

### Recent

The `recent` *message* requests a quantity of recent nodes of a given type. This is useful when attempting to discover new identity and community nodes.

#### Message Structure

```
recent <message_id> <node_type> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_type` should one of the arbor forest node types defined [here](forest.md) as a decimal integer.
- `quantity` should be the number of nodes requested. The response is guaranteed to have less than or equal to this many elements.

#### Possible Responses

- `results`
- `status`

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
<node_id_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *node ids* that follow the header row (one per line).
- `node_id_line` is described in [the section on Node ID Lines](#node-id-lines)

#### Possible Responses

- `results`
- `status`

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
<counted_node_id_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *coutned node id lines* that follow the header row (one per line).
- `counted_node_id_line` is described in the section on [Counted Node ID Lines](#counted-node-id-lines).
 
#### Possible Responses

- `results`
- `status`

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

- `results`
- `status`

#### Message Structure

```
leaves_of <message_id> <count>
<counted_node_id_line>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *counted node id lines* that follow the header row (one per line).
- `counted_node_id_line` is described in the section on [Counted Node ID Lines](#counted-node-id-lines).

#### Example

```
leaves_of 101 1
45 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
```

A request for the 45 most recent leaf nodes of the given node.

### Subscribe

The `subscribe` *message* requests that updates to a list of community nodes be shared over the current connection in real time. This goes both directions. If a subscribe is accepted, both sides agree to share new nodes within that community as soon as they are discovered (by any means). The `subscribe` message is a multiple-response message. Each requested community node can be individually accepted or rejected by the other side of the connection.

#### Message Structure

```
subscribe <message_id> <count>
<node_id_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *community ids* that follow the header row (one per line).
- `node_id_line` is described in [the section on Node ID Lines](#node-id-lines).

#### Possible Responses

- `status`

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
<node_id_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *community ids* that follow the header row (one per line).
- `node_id_line` is described in [the section on Node ID Lines](#node-id-lines).

#### Possible Responses

- `status`

#### Example

```
unsubscribe 110 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Announce

The `announce` *message* contains a set of new nodes belonging to one of the connection's subscribed communities. This message is used to inform the other end of the connection of new content.

#### Message Structure

```
announce <message_id> <count>
<full_node_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *node lines* that follow the header row (one per line).
- `full_node_line` is described in [the section on Full Node Lines](#full-node-lines).

#### Possible Responses

- `status`

#### Example

```
announce 321 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk YNAPcdvwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5Fejek...
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM vwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5FekDNITsfYF...
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co 5Fe4EkkwkDNITsfYFFsTu95jM5Fe5Fe4EkkwkDNITsfYFFsTu95jM5Fe...
```

Three new nodes from a subscribed community being announced to the other end of the connection.

### Results

The `results` *message* contains a set of results for part (or all) of a previous request message.

#### Message Structure

```
results <target_message_id>[<index>] <count>
<full_node_line>
...
```

- `target_message_id` is the message id of the request message that this responds to.
- `index` is the request part index (0-based) that this is a response to. For instance, an `ancestry` request can ask for the histories of many different nodes. A response for the second of those nodes would have an `index` of `1`.
- `count` should be the number of *node lines* that follow the header row (one per line).
- `full_node_line` is described in [the section on Full Node Lines](#full-node-lines).

#### Example

```
results 44[2] 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk YNAPcdvwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5Fejek...
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM vwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5FekDNITsfYF...
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co 5Fe4EkkwkDNITsfYFFsTu95jM5Fe5Fe4EkkwkDNITsfYFFsTu95jM5Fe...
```

A response for the third part of request `44` containing three nodes.

### Status

The `status` *message* indicates the success or failure of a part of a previous request.

#### Message Structure

```
status <target_message_id>[<index>] <status_code>
```

- `target_message_id` is the message id of the request message that this responds to.
- `index` is the request part index (0-based) that this is a response to. For instance, an `ancestry` request can ask for the histories of many different nodes. A response for the second of those nodes would have an `index` of `1`.
- `error_code` is one of the codes listed in [Error Codes](#error-codes).

#### Example

```
status 44[3] 3
```

This message indicates that the fourth component of the request with `message_id` 44 referred to a node that is unknown to the other end of the connection.

## Status Codes

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
        Ok
        </td>
        <td>
        the request was successful
        </td>
    </tr>
    
    <tr>
        <td>
        1
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
        2
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
        3
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
        4
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
server -> client: version | status (unsupported)

client -> server: recent communities
server -> client: results (of communities) | status (error)

client -> server: unsubscribe | subscribe (to communities)
server -> client: status

peer1 -> peer2: announce
peer2 -> peer1: status

peer1 -> peer2: recent | leaves_of
peer2 -> peer1: results | status

peer1-> peer2: query N | ancestry N
peer2 -> peer1: results | status
```

Encoding:

- node ids are their base64url versions (produced by MarshalText)
- ndoes are their base64url encoded binary format (produced by MarshalBinary
