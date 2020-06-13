---
title: Getting Started with Wisteria
---

## Installation

You'll need to download the latest client version for your operating system from the [release page](https://git.sr.ht/~whereswaldon/wisteria/refs). Choose the most top list item (click on the version number) and then find the download link. Here's how to choose:

- macOS: Choose the one with `macOS_x86_64` in the name
- Windows: Choose the one with `windows_x86_64` in the name
- Linux: Choose the one with `Linux_x86_64` in the name (unless you're on a different architecture like a raspberry pi)

Once you have the file, unpack the archive. This can generally be accomplished by double-clicking it in your file manager. You should be left with a folder that contains an executable file called `wisteria` (`wisteria.exe` on Windows).

Move that executable file wherever you'd like. You just need to remember where so that you can navigate there in a terminal later on.

## Create your account

An Arbor account is called an Identity. If you already have a [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) key, `wisteria` can be launched with <flag> FIXME to use that key for Identity creation. If you don't have a key, no worries.

Open a terminal and navigate to the folder where you put the `wisteria` executable. Run:

```shell
# launch the client connected to our server infrastructure
./wisteria arbor.chat:7117
```

Select "Create New Identity" and follow the prompts. If you provided your own PGP key, you might be prompted to enter the password.

## Using Wisteria

You can use the arrow keys (or h/j/k/l) to scroll your cursor between messages. The red message is "selected," and determines the coloration of all other visible messages. Yellow messages are "ancestors" of the selected message (it is a reply to them), whereas green messages are "descendants" of the selected message.

You can filter the history to only messages related to the selected message (ancestors and descendants) by pressing the spacebar. Press it again to turn this filter off.

To reply to the selected message, just hit Enter (or Return), type your message, then press Enter (or Return) again. You may be prompted to enter your GPG key passphrase. After that, you should see your new message appear in `wisteria` and it will be sent to other connected relays.

To start a new conversation (not related to your currently selected reply) press `c` instead of Enter. You compose your new message in the same way.

You can see the `wisteria` log by pressing `L` (press it again to switch back to history).


## Updating Wisteria

Follow the directions for [installing wisteria](#Installation), then just launch it.

## Going Further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
