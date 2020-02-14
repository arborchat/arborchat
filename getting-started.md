---
title: Getting Started with Arbor
---

It only takes a few steps to get connected in Arbor!

## Installation

You'll need to install our current client program for Arbor. Right now, this requires [Go 1.13+](https://golang.org/dl/), though we are working to eliminate this dependency. To set everything up quickly, you can just run:

```shell
env GOPRIVATE=git.sr.ht GO111MODULE=on go get git.sr.ht/~whereswaldon/wisteria@latest
```

You'll need Go's default installation directory in your `$PATH`:

```shell
export PATH="$PATH:$HOME/go/bin"
```

To make this permanent, add it to your shell's startup files.

## Setup

Once you have the tools, we need to make a place to store your Arbor history. Any folder will do. If you're on Linux, a BSD, or macOS, just run:

```shell
mkdir ~/ArborHistory
cd ~/ArborHistory
```

If you're on Windows, create a new folder and open `cmd.exe` there.

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

Now we create your Arbor Identity by launching `wisteria`, our client program. From inside of your new `ArborHistory` directory, run:

```shell
# launch the client connected to our server infrastructure
wisteria arbor.chat:7117
```

Select "Create New Identity" and then select your new GPG key. You should be prompted to enter your key's passphrase in order to sign your new identity.

Next you'll be asked to select an "Editor Command". This is the program that you will use to compose new messages. Choose the option that you like best (we're working to add a wider range of support for editors).

## Using Wisteria

You can use the arrow keys (or h/j/k/l) to scroll your cursor between messages. The red message is "selected," and determines the coloration of all other visible messages. Yellow messages are "ancestors" of the selected message (it is a reply to them), whereas green messages are "descendants" of the selected message.

You can filter the history to only messages related to the selected message (ancestors and descendants) by pressing the spacebar. Press it again to turn this filter off.

To reply to the selected message, just hit Enter (or Return). This will open the Editor Command that you selected earlier. Type your reply in this editor, then *save and quit* the editor program. You may be prompted to enter your GPG key passphrase. After that, you should see your new message appear in `wisteria` and it will be sent to other connected relays.

To start a new conversation (not related to your currently selected reply) press `c` instead of Enter. You compose your new message in the same way.

You can see the `wisteria` log by pressing `L` (press it again to switch back to history).

## Going Further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
