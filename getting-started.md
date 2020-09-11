---
title: Getting Started with Arbor
---

It only takes a few steps to get connected in Arbor!

# Installation
[Sprig](https://git.sr.ht/~whereswaldon/sprig) is currently the best way to experience Arbor but there is also a CLI client called `wisteria` for which there is a separate [getting started guide](./getting-started-cli.md). To download the latest version, head to the [release page](https://git.sr.ht/~whereswaldon/sprig/refs). Choose the topmost list item (click the version number) then find your download link. The Windows release has `windows` in the filename, Linux has `linux`, and so on.

If you're on Android, there is also an APK available for download. However, you'll need to have your phone in developer mode, installation from unknown sources enabled, etc. If you don't, don't worry about it and simply wait until it's released in [F-Droid](https://f-droid.org/) or Google Play. A version for iOS is in the works.

Once you have the file, unpack the archive. Double-click it in your file manager or run `tar xvf <file-name>` from the Linux or macOS command line. You'll then have a single executable named `sprig` in that directory. Move that wherever you'd like but remember its location for later.

# Creating your account

Arbor accounts are called Identities and creation is quite simple. Navigate to where you stored the `sprig` binary and execute it. Double-click the file in a graphical file manager or use `./sprig` from a Linux or macOS terminal. Once the application opens, confirm that messages are immutable (once sent, you cannot delete or edit a message) then enter `arbor.chat:7117` and click `Connect`. Make sure you *don't* press enter as that currently inserts a newline character and the connection fails. After typing the address, simply click the button.

On the next screen, select "Create new Identity", enter your desired username, then click `Create`. From there, simply click `View These Communities`!

# Using Sprig

By default, the most recent message is **selected**. When selecting another message, it slides to the right and its ancestors and children are teal and animate accordingly. Children indent relative to the selected message and ancestors are in line with it. **Conversation roots** are dark green. These are parents which other replies branch from. As a general rule of thumb, if your message not a direct reply to something, it should be a **Conversation root**.

To the right of the selected message, there is a `Reply` button. Clicking that reveals a dialogue at the bottom of the screen where you can type your reply. The clipboard to the left of the text entry field is for pasting text from your clipboard and the button to the right is for sending the message. Clicking the `×` in the top right of that dialogue dismisses it.

At the top of the message view, there are four buttons. From left to right:

- Hamburger menu
  - Switch between the settings, the conversation view, and other pages
- Plus Button
  - Compose a **Conversation root** message
- Filter Button
  - Only display messages that are direct parents or children of the selected message
- Kebab menu
  - Overflow menu containing additional options. At the moment, those include jumping to the top and bottom of the conversation view.

## Keyboard short cuts
On desktop, the following short cuts are available:

- `f` and `Space` to toggle the filter
- `c` to create a new conversation root
- `Enter` replies to the selected message
- `j`/`k` are Vi key bindings for scrolling: `j` is down and `k` is up. Arrow keys work as well.
- `g`/`G` are Vi key bindings for jumping: `g` jumps to the top of the grove and `G` jumps to the bottom. `Home` and `End` work as well.

# Updating Sprig

Simply follow the directions for [installing Sprig](#Installation) then just launch it. Feel free to delete the old binary if you wish.

# Going further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
