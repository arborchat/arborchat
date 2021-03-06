---
title: Forest Data Structure Specification
---

# The Arbor Forest Specification

Arbor models chat conversations as a group of Tree data structures.
This particular collection of trees is called the "Arbor Forest", and
this document specifies its structure.

## Definitions

- Node - any element in one of the trees in the Arbor forest.
- Id - the cryptographic hash of the data in a Node is its ID. Each node type specifies the exact method needed to compute its ID correctly.
- Root Node - any Node with no parent (parent ID is the Null Hash)
- Conversation Node - a Reply node that is the direct child of a Community. It is the root of a subtree of Reply nodes, and can be identified by being at Depth 1 and having the Null Hash as a `conversation_id`.

## Nodes

There are three types of Node:

- Identity: these Nodes represent a user of Arbor and consist primarily of a public/private key pair and a human-readable name.
- Community: these Nodes serve as the root node for a group of users' conversations.
- Reply: these Nodes are the children of either Community Nodes or other Reply Nodes, with each Reply representing a single message from an Arbor user.

### Field Types

The Arbor Forest uses a number of common field types with specific meanings. These types are defined here and will be used to describe each field below.

- **Node Type**: an 8-bit unsigned integer indicating the type of this Node. Possible values are:
  - 1: Identity
  - 2: Community
  - 3: Reply
- **Hash Type**: an 8-bit unsigned integer representing a particular hash algorithm. Possible values:
  - 0: Null Hash, this indicates that this is not a hash value and it has no data content whatsoever. If this NodeType shows up in a Qualified Hash, it will have length of 0 and (correspondingly) no data bytes whatsoever.
  - 1: SHA512
- **Content Type**: an 8-bit unsigned integer representing a particular content structure (analogous to a MIME type). Valid values are:
  - 0: binary, unknown
  - 1: UTF8 text
  - 2: [TWIG](#twig) (a simple key-value format described later in this document).
- **Key Type**: an 8-bit unsigned integer representing kind of public key. Valid values are:
  - 1: OpenPGP RSA Public Key
- **Signature Type**: an 8-bit unsigned integer representing a kind of cryptographic signature. Valid values are:
  - 1: OpenPGP RSA binary signature
- **Content Length**: an unsigned 16-bit integer representing how many bytes are in another field.
- **Hash Descriptor**: A Hash Type followed by a Content Length. The Content Length specifies how many bytes the hash digest output should be. These two pieces of data fully specify the hash procedure needed to construct a given hash.
- **Tree Depth**: an unsigned 32-bit integer indicating how many levels beneath the root of a particular tree a given node is.
- **Timestamp**: an unsigned 64-bit integer indicating the number of milliseconds since the start of the UNIX Epoch (January 1, 1970, 12:00:00 GMT)
- **Blob**: binary data with an unspecified length. Blobs should never be used without additional data clarifying their size and the nature of their contents.
- **Qualified Hash**: A Hash Descriptor followed by a Blob. This encodes both the procedure necessary to derive the hash value as well as the expected result. Special values:
  - If the **Hash Type** is 0 and the **Content Length** is zero, this is a reference to the _Null Hash_. This will usually be used in the `parent` field of nodes that are the root of a tree within the Arbor Forest.
- **Qualified Content**: A Content Type followed by a Content Length followed by a Blob of content.
- **Qualified Key**: A Key Type followed by a Content Length followed by a Blob holding a public key.
- **Qualified Signature**: A Signature Type followed by a Content Length followed by a Blob containing a signature.
- **SchemaVersion**: A 16 bit unsigned integer representing the version of the node schema that a node uses. This document specifies schema version 1. The value 0 is reserved for future use.

### Common Fields

All nodes in the forest share some fields. These are described generally here, though each node type's description may contain more detailed information about the legal values in each field for that node type.

Common fields:

- `version` **SchemaVersion**: the version of the node schema in use.
- `node_type` **Node Type**: the type of the node within the Forest.
- `parent` **Qualified Hash**: the hash of the parent tree node. For Identity and Community nodes, this will always be the null hash **of all zeroes**
- `id_desc` **Hash Descriptor**: the hash algorithm and digest size that should be used to compute this Node's ID
- `depth` **Tree Depth**: the number of levels this node is from the root message in its tree. Root messages will be 0, their immediate child nodes should be 1.
- `created` **Timestamp**: when this node was created.
- `metadata` **Qualified Content**: [TWIG](#twig) data. Only valid if ContentType is TWIG.
- `author` **Qualified Hash**: the ID of the Identity node that signed this node
- `signature` **Qualified Signature**: the actual binary signature of the node. The structure of this field varies by the type of key in the `author` field. The ContentType of this field should be a signature type of some kind.

### Common Structure

All node types are signed and hashed with their data laid out in a specific order on the wire. The procedure for constructing the layout used for hashing and signing is as follows:

Determine the values of these fields:

- `version`
- `node_type`
- `parent`
- `id_desc`
- `depth`
- `created`
- `metadata`
- `author`
- all node-specific fields **order specified in the description of each node type**

Write them into a buffer in the order above, with all integers written in network byte order (**big endian**).

Sign the contents of the buffer using the key pointed to by `author`, and use it to create the value of `signature`.

Concatenate the value of `signature` to the end of the existing buffer, then hash the entire buffer with the algorithm and digest size specified by `id_desc` to determine the node's actual ID.

### Identity

An Identity node has the following fields:

- `name` **Qualified Content**: must be of type UTF8. The name of the user who controls this key. Maximum length (in bytes) is 256.
- `public_key` **Qualified Key**: the binary representation of the public key

These fields should be processed in the order given above when signing and hashing the node.

### Community

A Community node has the following fields:

- `name` **Qualified Content**: must be of type UTF8. The name of the user who controls this key. Maximum length (in bytes) is 256.

These fields should be processed in the order given above when signing and hashing the node.

### Reply

A Reply node has the following fields:

- `community_id` **Qualified Hash**: the node ID of the community node at the root of the tree containing this reply.
- `conversation_id` **Qualified Hash**: the node ID of the first reply node in the ancestry of this reply (depth 1).
- `content` **Qualified Content**: the message content.

These fields should be processed in the order given above when signing and hashing the node.

## Encoding Node IDs

Often applications will want to represent Arbor node IDs as strings. The recommended string encoding for a node ID is the following components concatenated:

- Hash algorithm prefix
- Underscore delimiter
- Size of hash digest in bytes (prefixed by a `B`)
- Double underscore delimiter
- Hash digest value in base64url encoding

An example of such a string encoding is: `SHA512_B32__CZMk9Gv5g4GYNAPcdvwkDNITsfYFFsTu95jM5Fe4Ekk`

Values of this form can be decoded by breaking them at the first occurrence of a double underscore, then decoding the component before it to determine the algorithm and length. The data following the double underscore (when base64url-decoded) should be the length specified after the `B` prefix (implementations should check this).

## TWIG

TWIG is a simple data format for key-value pairs of data.

Keys and values are separated by NULL
bytes (bytes of value 0). Keys and values may not contain a NULL byte.
All other characters are allowed.

Keys have an additional constraint. Each key must contain a "name" and a "version"
number. These describe the semantics of the data stored for that key, and the
precise meaning is left to the user. The key and name are separated (in the binary
format) by a delimiter, which is currently '/'.

The key name may not be empty, but values may be empty. Empty values must still be surrounded by NULL bytes.

In practice, TWIG keys look like (the final slash is the delimiter between key
and version):

| TWIG Key                 | Key name               | Key Version |
| ---                      | ---                    | ---         |
| anexample/235            | anexample              | 235         |
| heres one with spaces/9  | heres one with spaces  | 9           |
| heres/one/with/slashes/9 | heres/one/with/slashes | 9           |


