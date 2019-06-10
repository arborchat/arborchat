![arbor logo](https://git.sr.ht/~whereswaldon/forest-go/blob/master/img/arbor-logo.png)

# What is Arbor?

Arbor is an open-source chat collaboration system that thinks a little differently about conversations. Arbor captures more of the context of messages than traditional chat, allowing you and your peers to communicate more clearly with less effort.

# Why is it called Arbor?

An arbor is an artificial structure that supports the growth of climbing vines in a garden. Arbor is an artificial structure for chat that helps conversation flourish.

# How is it different?

Arbor messages track what you were responding to when you wrote them. Every message explicitly has a "parent" message that it is a response to. This allows Arbor to visualize the relationships between messages for its users in a way that other chat systems cannot. This makes your conversation history into a [tree](https://en.wikipedia.org/wiki/Tree_(data_structure)) instead of a list.

If you think about it, most things you say in a conversation are a response to what someone else just said. Arbor simply captures that information and uses it to help you make sense of very large conversations. Ever get confused when many people respond to a message at around the same time? Arbor makes that situation coherent.

# Status

Arbor started in February 2018 as a wacky idea. We implemented a proof-of-concept system that embodies chat as a tree over the course of the next ten months, and we were really pleased by the results. However, this system had some serious flaws due to its proof-of-concept nature. It had no security, and no good way to build security. We've started over, but this time we're building something serious. It takes a lot of work to build a secure communication platform from the ground up, so it's slow going.

For the new implementation, we have these components built:

- [forest-go](https://git.sr.ht/~whereswaldon/forest-go): a library for creating and manipulating messages (nodes) in the Arbor system

For our proof-of-concept implementation, there is:

- [protocol](https://github.com/arborchat/protocol): a specification of the protocol
- [arbor-go](https://github.com/arborchat/arbor-go): a golang implementation of the protocol
- [server](https://github.com/arborchat/server): a simple arbor server
- [muscadine](https://github.com/arborchat/muscadine): a terminal arbor client
- [trellis](https://git.sr.ht/~whereswaldon/trellis): a (poorly made) experiment at building a web ui for arbor
- [kudzu](https://github.com/arborchat/kudzu): a test program that replies with long random messages
- [ivy](https://github.com/arborchat/ivy): an old test client
- [pergola](https://github.com/arborchat/pergola): the first arbor chat client; has a terrible UX
- [yggdrasil](https://github.com/arborchat/yggdrasil): an arbor chat client in C
