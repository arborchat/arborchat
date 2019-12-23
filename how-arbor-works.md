title: How Arbor Works
---

Arbor is a decentralizable, tree-based real-time collaboration platform. It consists of a set of data structures, protocols, and applications that together provide security, flexibility, and integrity. This document explores each component of Arbor and explains how they are combined to create the system that exists today.

## Forest: the chat data structure

Arbor stores conversation as "nodes" organized into many "trees."

Trees are rooted at either an "Identity" or "Community" node. Identity nodes represent a single user account. They combine a user's name in Arbor with a public key. Community nodes serve as the root nodes for trees of conversation relevant to a group of users. A community node primarily contains a name for the community.

The final node type is a "Reply" node. Reply nodes are messages to other users, and they are child nodes of either other Reply nodes or Community nodes.

Here's an example of the relationship between the three kinds of nodes. A node's parent is indicated by a solid line pointing at its parent, and a node's author (the identity which created it) is indicated by a dashed gray line.

```graphviz
digraph forest {
    rankdir=BT
    IdentityA [rank=0,label="Identity: Alice"]
    IdentityB [rank=0,label="Identity: Bob"]
    CommunityA [rank=0,label="Community: Cryptography"]
    CommunityB [rank=0,label="Community: Arbor"]

    ReplyA [rank=1]
    ReplyB [rank=1]
    ReplyC [rank=2]

    ReplyD [rank=1]
    ReplyE [rank=2]
    ReplyF [rank=2]
    ReplyG [rank=3]
    
    ReplyA -> CommunityA
    ReplyA -> IdentityA [label="author",color="gray",style="dashed"]
    ReplyB -> CommunityA
    ReplyB -> IdentityB [label="author",color="gray",style="dashed"]
    ReplyC -> ReplyB
    ReplyC -> IdentityA [label="author",color="gray",style="dashed"]
    
    ReplyD -> CommunityB
    ReplyD -> IdentityA [label="author",color="gray",style="dashed"]
    ReplyE -> ReplyD
    ReplyE -> IdentityB [label="author",color="gray",style="dashed"]
    ReplyF -> ReplyD
    ReplyF -> IdentityA [label="author",color="gray",style="dashed"]
    ReplyG -> ReplyF
    ReplyG -> IdentityB [label="author",color="gray",style="dashed"]
}
```

Every node is referenced by a "node ID" that is a cryptographic hash of that node's content. Every node has a node ID for its own parent and author embedded inside of itself. Additionally, every node is signed by the public key embedded within its author Identity node.

Since every node is referenced by a hash of its contents and every node is signed by its author, we gain the following properties:

Given a node from an *untrusted* source:

- if we already have (and trust) the `author` node referenced in the new node:
    - we can validate the signature of the node to ensure that it hasn't been tampered with since it was authored. If that validation passes, we can then be confident that not only is this node valid, but its parent node is also the node that was intended to be its parent. We can then fetch and validate each parent node until we reach nodes that we already have available to validate the entire history of the conversation up to the node we just received.
- if we don't already have the `author` node referenced in the new node:
    - we can ask other Arbor systems for its parent and author nodes (using their node IDs) and then we can validate that the data we get back is correct by hashing it ourselves. If we get back the author's Identity node from a peer and the hash is correct, we can then verify the signature to ensure that the node really was authored by the user with that Identity (we don't necessarily trust this user, but at least they control the keys that signed the message).

This means that we can safely acquire Arbor nodes from any source and validate that they are either legitimate (if sent by trusted authors) or internally-consistent elaborate scams.

The fact that Arbor nodes can be freely exchanged over any method of communication makes the ecosystem as a whole very flexible. During development, we have exchanged nodes via email, DropBox, Syncthing, http, and custom protocols. The great thing is that none of these methods are mutually exclusive with the others. This gives us the capability to build a robust system that can survive the failure of core components.

Forest is specified [here](/specifications/forest.md), and we have a Go library for creating and manipulating nodes in the forest [here](https://git.sr.ht/~whereswaldon/forest-go).

## Grove: chat history repository

We store Forest nodes on disk in a file-system hierarchy called a "Grove". Think of it like a git repository, but for conversations. The specification for the layout of a Grove is in flux, so we don't have a formal document for it right now.

Groves have to follow two simple rules in order to be valid:

1. Never insert a node that cannot be validated by nodes already in the grove.
2. Never insert a node that fails validation.

If this principle is obeyed, multiple programs can concurrently access the grove and can trust that insertions into the grove are valid.

The existing implementation of the logic for managing a grove can be found in Go [here](https://git.sr.ht/~whereswaldon/forest-go/tree/master/grove).
