---
title: Arbor Chat
date: 2019-12-12Z21:54:11-05:00
draft: false
---

![arbor logo](https://git.sr.ht/~whereswaldon/forest-go/blob/master/img/arbor-logo.png)

# About

## What is Arbor?

Arbor is an open-source chat collaboration system that thinks a little differently about conversations. Arbor captures more of the context of messages than traditional chat, allowing you and your peers to communicate more clearly with less effort.

## Why is it called Arbor?

An arbor is an artificial structure that supports the growth of climbing vines in a garden. Arbor is an artificial structure for chat that helps conversation flourish.

## How is it different?

Arbor messages track what you were responding to when you wrote them. Every message explicitly has a "parent" message that it is a response to. This allows Arbor to visualize the relationships between messages for its users in a way that other chat systems cannot. This makes your conversation history into a [tree](https://en.wikipedia.org/wiki/Tree_(data_structure)) instead of a list.

If you think about it, most things you say in a conversation are a response to what someone else just said. Arbor simply captures that information and uses it to help you make sense of very large conversations. Ever get confused when many people respond to a message at around the same time? Arbor makes that situation coherent.

# Status

Arbor started in February 2018 as a wacky idea. We implemented a proof-of-concept system that embodies chat as a tree over the course of the next ten months, and we were really pleased by the results. However, this system had some serious flaws due to its proof-of-concept nature. It had no security, and no good way to build security. We've started over, but this time we're building something serious. It takes a lot of work to build a secure communication platform from the ground up, so it's slow going.

## Components

For the new implementation, we have:

- [specifications](specifications): programming-language-agnostic
  descriptions of the formats, conventions, and protocols that Arbor
  uses.
- [wisteria](https://git.sr.ht/~whereswaldon/wisteria): a terminal client for arbor.
- [forest-go](https://git.sr.ht/~whereswaldon/forest-go): a library for creating and manipulating messages (nodes) in the Arbor system.
- [sprout-go](https://git.sr.ht/~whereswaldon/sprout-go): a library for speaking the sprout protocol (our simple node exchange protocol).
- sinensis: the reference arbor relay implementation (relays are like servers in a conventional system, except that everybody runs one). The code for this currently lives [here](https://git.sr.ht/~whereswaldon/sprout-go/tree/relay/cmd/relay), but will be moved into its own repo once it reaches a point of maturity.

For our proof-of-concept implementation, there is:

- [protocol](https://github.com/arborchat/protocol): a specification of the protocol
- [arbor-go](https://github.com/arborchat/arbor-go): a golang implementation of the protocol
- [server](https://github.com/arborchat/server): a simple arbor server
- [muscadine](https://github.com/arborchat/muscadine): a terminal arbor client
- [trellis](https://git.sr.ht/~whereswaldon/trellis): a (poorly made) experiment at building a web UI for arbor
- [kudzu](https://github.com/arborchat/kudzu): a test program that replies with long random messages
- [ivy](https://github.com/arborchat/ivy): an old test client
- [pergola](https://github.com/arborchat/pergola): the first arbor chat client; has a terrible UX
- [yggdrasil](https://github.com/arborchat/yggdrasil): an arbor chat client in C

## Get Involved

If you'd like to keep up with what's going on in Arbor or to help us build it, you can:

- Join our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)
  - When you click "Subscribe," it will open an email client with a new message. Send literally *anything* to that email address and you'll be subscribed to the mailing list.
- Check out our [open issues](https://todo.sr.ht/~whereswaldon/arbor-dev) if you'd like to help out or report bugs.

Who do we need?

- Developers: there's a mountain of code that we need to write before the new implementation can go live. If you want to get involved, we're happy to have you. Many design decisions have not yet been made, and there's a lot of opportunity to shape the direction of the project.

Who will we need?

- Users: just using Arbor and telling us what you think about it is immeasurably valuable.
- Designers: it's easy to build a capable tool that is crippled by a terrible user experience. We could really use people who can help us avoid that pitfall. Additionally, there's a lot of space for innovation in tree-based chat. There aren't many user interfaces like this, and we think some really cool things are possible.

# FAQ

### Where did the logo come from?

The inspiration for the logo was a sketch by Katerina Waldon. Chris Waldon hacked together the current one in Inkscape.

### Why is some stuff on GitHub and some stuff on SourceHut?

When the project started, we didn't know sourcehut existed. We really like some of the ideas behind sourcehut, and we're trying it out for the time being as a possible permanent home for the project. We will try to mirror all of our code back to GitHub to make it all easy to find though.

### Why make a new chat application? Isn't the market saturated enough?

Sure; there are hundreds of other applications that do chat, and many of them are very good tools. Arbor's goal isn't to replace them all, but to demonstrate that there are other interesting ways to build chat.
