---
title: Getting Started with Arbor
---

It only takes a few steps to get connected in Arbor!

## Installation

You'll need to download our latest client program release for your operating system.
You can find our releases listed [here](https://git.sr.ht/~whereswaldon/wisteria/refs). Choose the latest release (click on the version number) and then find the download for your Operating System. Here's how to choose:

- macOS: Choose the one with `macOS_x86_64` in the name
- Windows: Choose the one with `windows_x86_64` in the name
- Linux: Choose the one with `Linux_x86_64` in the name (unless you're on a different architecture like a raspberry pi)

Once you have the file, double-click it to extract the archive. You should be left with a folder that contains an exectuable file called `wisteria` (`wisteria.exe` on Windows).

Move that exectuable file wherever you'd like. You just need to remember where so that
you can navigate there in a terminal later on.

## Create your account

An Arbor account is called an Identity. You'll need to have `gpg` installed for this part.

- Linux users should almost certainly already have `gpg`. Try `which gpg` to check. If you don't have it, check your distribution's documentation for installation instructions.
- BSD users can check their OS documentation for the correct installation instructions.
- macOS users can install `gpg` with [`homebrew`](https://brew.sh/) by running `brew install gpg`.
- Windows users can install [`gpg4win`](https://www.gpg4win.org/).

Now we need to generate a GPG key. If you already have one, you can skip this part.

```shell
gpg --generate-key
```

Follow the prompts. Any information that you include in these prompts will be part of your Arbor Identity, so be careful not to use an email address that you aren't willing to share (you can omit your email if you want to).

Now we create your Arbor Identity by launching `wisteria`, our client program. Open a terminal and navigate to the folder where you put the `wisteria` executable. Run:

```shell 
# launch the client connected to our server infrastructure
./wisteria arbor.chat:7117
```

Select "Create New Identity" and then select your new GPG key. You should be prompted to enter your key's passphrase in order to sign your new identity.

## Using Wisteria

You can use the arrow keys (or h/j/k/l) to scroll your cursor between messages. The red message is "selected," and determines the coloration of all other visible messages. Yellow messages are "ancestors" of the selected message (it is a reply to them), whereas green messages are "descendants" of the selected message.

You can filter the history to only messages related to the selected message (ancestors and descendants) by pressing the spacebar. Press it again to turn this filter off.

To reply to the selected message, just hit Enter (or Return). You may be prompted to enter your GPG key passphrase. After that, you should see your new message appear in `wisteria` and it will be sent to other connected relays.

To start a new conversation (not related to your currently selected reply) press `c` instead of Enter. You compose your new message in the same way.

You can see the `wisteria` log by pressing `L` (press it again to switch back to history).


## Updating Wisteria

Follow the directions for [installing wisteria](#Installation), then just launch it without generating a new GPG key.

## Going Further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
