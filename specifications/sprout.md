---
title: Sprout Protocol 0.0 Specification
---

Sprout is a simple connection-oriented protocol for exchanging nodes
in the Arbor Forest (as defined by the [Arbor Forest specification](forest.md)).

Protocol requires an underlying transport that is connection-oriented and supports reliable delivery.

Sprout is an exchange of *messages*, where either side can send any message type.

## Message Structure

*Messages* consist of a single *header line* followed by zero or more lines of *content*. All lines, both *header* and *content* end with the ASCII newline character `\n`.

There are two types of *message*, *requests* and *responses*. Each *request* will have one *response*.

All *message header lines* begin with a plaintext *verb* indicating what kind of *message* they are.

There is no requirement to wait for a *response* before sending another *request*. Either party may choose to *respond* with an [error status](#status) message if the Sprout implementation cannot handle a sufficient number of in-flight requests.

In *request messages*, the second whitespace-delimited element of the header line is a *message ID*, which is a monotonically increasing unsigned integer (in decimal notation) that MUST be unique for the lifetime of the Sprout connection. Most *messages* have different headers after the *message ID*.

```
<verb> <message_id> [<header> ...]
[<content_line>]
...
```

In a *response message*, the second whitespace-delimited element of the header line is a *target message ID*, which indicates which *request message* the response corresponds to.

```
<verb> <target_message_id> [<header> ...]
[<content_line>]
...
```

## Content Line Types

Sprout messages that have a body of extra data after their header lines use one of several structures for each line of their body:

### Node ID Lines

A *node_id_line* just contains an encoded node ID for an Arbor Forest node using the encoding described [here](./forest.md#encoding-node-ids).

```
<node_id>
```

### Full Node Lines

A *full_node_line* contains an Arbor Forest node ID (encoded as in [Node ID Lines](#node-id-lines)) followed by the base64url-encoded value of that entire Arbor Forest Node.

```
<node_id> <node>
```

## Message Types


### Version

The version *message* is an advertisement of the sender's protocol version. It is intended to indicate to the other end of the connection what messages are understood.

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

An advertisement that the local client supports only the current unstable protocol version.

### List

The `list` *message* requests a quantity of recent nodes of a given type. This is useful when attempting to discover new identity and community nodes.

#### Message Structure

```
list <message_id> <node_type> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_type` should be one of the [Arbor Forest node types](forest.md) defined as a decimal integer.
- `quantity` should be the number of nodes requested. The response is guaranteed to have less than or equal to this many elements.

#### Possible Responses

- `response`
- `status`

#### Example

```
list 5 1 10
```

A request for ten community nodes.

### Query

The `query` *message* requests a list of specific nodes. This is useful when looking up specific node values (like when resolving the authors of Reply nodes).

#### Message Structure

```
query <message_id> <count>
<node_id_line>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `count` should be the number of *node IDs* that follow the header row (one per line).
- `node_id_line` is described in [the section on Node ID Lines](#node-id-lines)

#### Possible Responses

- `response`
- `status`

#### Example

```
query 27 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co
```

### Ancestry

The `ancestry` *message* requests the nodes prior to a list of nodes within the Arbor Forest up to a specified depth. This is useful when looking up the history of a collection of Leaf nodes.

#### Message Structure

```
ancestry <message_id> <node_id> <levels>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_id` is the ID of the node whose ancestry is being requested.
- `levels` is the desired number of levels of ancestry.

#### Possible Responses

- `response`
- `status`

#### Example

```
ancestry 44 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk 3
```

A request for three levels of ancestry for the listed node ID.

### Leaves Of

The `leaves_of` *message* requests a quantity of recent Leaf nodes in the subtree rooted at a specific node. This is useful for discovering recent conversations when you join a relay.

#### Possible Responses

- `response`
- `status`

#### Message Structure

```
leaves_of <message_id> <node_id> <quantity>
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_id` is the ID of the node that roots the subtree for which this message is querying leaves.
- `quantity` should be the number of Leaf nodes desired in the response.

#### Example

```
leaves_of 101 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk 45
```

A request for the 45 most recent Leaf nodes of the given node.

### Subscribe

The `subscribe` *message* requests that updates to a community node be shared over the current connection in real time. This goes both directions. If a subscribe is accepted, both sides agree to share new nodes within that community as soon as they are discovered (by any means).

#### Message Structure

```
subscribe <message_id> <node_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_id` is the identifier of the community that should be added to the connection's subscription list.

#### Possible Responses

- `status`

#### Example

```
subscribe 20 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
```

### Unsubscribe

The `unsubscribe` *message* requests that updates to a community node no longer be shared over the current connection. This goes both directions. `unsubscribe` messages MUST be honored by both sides, but the request may error if attempting to unsubscribe from a non-subscribed or nonexistent community.

#### Message Structure

```
unsubscribe <message_id> <node_id>
...
```

- `message_id` should be a unique unsigned integer that has not been sent to the remote side of the connection before.
- `node_id` is the identifier of the community that should be added to the connection's subscription list.

#### Possible Responses

- `status`

#### Example

```
unsubscribe 110 SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk
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

### Response

The `response` *message* contains a set of response for part (or all) of a previous request message.

#### Message Structure

```
response <target_message_id> <count>
<full_node_line>
...
```

- `target_message_id` is the message ID of the request message that this responds to.
- `count` should be the number of *node lines* that follow the header row (one per line).
- `full_node_line` is described in [the section on Full Node Lines](#full-node-lines).

#### Example

```
response 44 3
SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk YNAPcdvwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5Fejek...
SHA512_B32__TlztQX6enWYO3EXlDg1_F6tXOpiSxlGr7nZTNF530lM vwkDNITsfYFFsTu95jM5Fe4EkkwkDNITsfYFFsTu95jM5FekDNITsfYF...
SHA512_B32__d2XDjNrF03bFAUP6V_Nou1O28n9V1nWCWyvPdO5C0co 5Fe4EkkwkDNITsfYFFsTu95jM5Fe5Fe4EkkwkDNITsfYFFsTu95jM5Fe...
```

A response for request `44` containing three nodes.

### Status

The `status` *message* indicates the success or failure of a previous request.

#### Message Structure

```
status <target_message_id> <status_code>
```

- `target_message_id` is the message ID of the request message that this responds to.
- `error_code` is one of the codes listed in [Error Codes](#error-codes).

#### Example

```
status 44 3
```

This message indicates that the request with `message_id` 44 referred to a node that is unknown to the other end of the connection.

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
        the request refers to a Forest node that is not known
        </td>
    </tr>
  </tbody>
</table>

## Procedure:

An example of the sequence of messages echanged by an Arbor client and an Arbor relay.

The `|` symbol denotes "OR", and is used to indicate that one of several messages may be sent.

```
# check version compatibility
client -> relay: version
client <- relay: version | status (unsupported)

# check which communities are available
client -> relay: list communities
client <- relay: response (of communities) | status (error)

# subscribe to relevant communities
client -> relay: unsubscribe | subscribe (to communities)
client <- relay: status

# client fills out message history by querying for past nodes
client -> relay: list | leaves_of | query | ancestry
client <- relay: response | status

# announce new nodes authored by the client
client -> relay: announce
client <- relay: status

# announce new nodes discovered by the relay
client <- relay: announce
client -> relay: status

# client leaves a community
client -> relay: unsubscribe
client <- relay: status

```
