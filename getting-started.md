---
title: Getting Started with Arbor
---

It only takes a few steps to get connected in Arbor!

## Installation

Arbor needs several software components in order to run effectively. Right now, you'll need [Go 1.13+](https://golang.org/dl/) installed in order to install Arbor, though we are working to eliminate this dependency. To set everything up quickly, you can just run:

```shell
# download latest tools (requires go 1.13)
env GOPRIVATE=git.sr.ht GO111MODULE=on go get git.sr.ht/~whereswaldon/sprout-go/cmd/relay@latest
env GOPRIVATE=git.sr.ht GO111MODULE=on go get git.sr.ht/~whereswaldon/wisteria@latest
```

## Setup

Once you have the tools, we need to make a place to store your Arbor history. Any folder will do. If you're on Linux, a BSD, or macOS, just run:

```shell
mkdir ~/ArborHistory
cd ~/ArborHistory
```

If you're on Windows, create a new folder and open `cmd.exe` there.

We need to generate a few cryptographic keys for the `relay` program to run correctly. From within your new folder, run:

```shell
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
```

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
wisteria
```

Select "Create New Identity" and then select your new GPG key. You should be prompted to enter your key's passphrase in order to sign your new identity.

Next you'll be asked to select an "Editor Command". This is the program that you will use to compose new messages. Choose the option that you like best (we're working to add a wider range of support for editors).

You should now be presented with the `wisteria` interface, but it should be empty. It's time to connect to the Arbor Network!

## Connect to Arbor

We now need to run `relay` to connect to the Arbor network. Open another terminal (or `cmd.exe` on Windows) and navigate to the same new directory that you used to run `wisteria`. Run the following to start your `relay`:

```shell
# launch a local relay connected to master relay
relay -certpath cert.pem -keypath key.pem -grovepath . arbor.chat:7117
```

You should see log messages about connecting and subscribing. Wait a little bit for your relay to start pulling history from the rest of the relay network (should be less than a minute though). Soon you should see lots of log lines flowing from your `relay`, and messages should start appearing in `wisteria`.

## Using Wisteria

You can use the arrow keys (or h/j/k/l) to scroll your cursor between messages. The red message is "selected," and determines the coloration of all other visible messages. Yellow messages are "ancestors" of the selected message (it is a reply to them), whereas green messages are "descendants" of the selected message.

To reply to the selected message, just hit Enter (or Return). This will open the Editor Command that you selected earlier. Type your reply in this editor, then *save and quit* the editor program. You may be prompted to enter your GPG key passphrase. After that, you should see your new message appear in `wisteria` and it will be sent to other connected relays.

To start a new conversation (not related to your currently selected reply) press `c` instead of Enter. You compose your new message in the same way.

## Going Further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
