---
title: Getting Started with Arbor
---

It only takes a few steps to get connected in Arbor!

# Installation
[Sprig](https://git.sr.ht/~whereswaldon/sprig) is currently the best way to experience Arbor but there is also a CLI client called `wisteria` for which there is a separate [getting started guide](./getting-started-cli.md). To download the latest version, head tot he [release page](https://git.sr.ht/~whereswaldon/sprig/refs). Choose the topmost list item (click the version number) then find your download link. The Windows release will have `windows` in the file name, Linux will have `linux`, and so on.

If you're on Android, there is also an APK that can be downloaded and installed. However, you'll need to have your phone in developer mode, installation from unknown sources enabled, etc. If you don't, don't worry about it and simply wait until it's released in [F-Droid](https://f-droid.org/) or Google Play. A version for iOS is in the works.

Once you have the file, unpack the archive. This can generally be accomplished by double-clicking it in your file manager or you can just use `tar xvf <file-name>` from the Linux or macOS command line. You'll be left with a single executable named `sprig`. Move that wherever you'd like but remember its location for later.

## Create your account

An Arbor account is called an Identity and creation is quite simple. Open a terminal, navigate to the folder where you put the `sprig` executable, and double-click it. Confirm that messages are immutable then enter `arbor.chat:7117` and click `Connect`. Make sure you *don't* press enter as that will currently insert a newline character and the connection will fail. After typing the address, just click the button.

On the next screen, select "Create new Identity", enter your desired username, then click `Create`. From there, simply click `View These Communities`!

## Using Sprig

By default, all messages are **unselected**. When you tap one, it becomes **selected** and its ancestors and children will be a darker colour. To the right of the selected message, there is a `Reply` button. Clicking that will reveal a dialogue at the bottom of the screen where you can type your reply. The clipboard to the left of the text entry field is for pasting text from your clipboard and the button to the right is for sending the message. Clicking the `×` in the top right of that dialogue will dismiss it.

At the top of the message view, there are four buttons.

- Back
  - Simply used to return to the main screen
- Copy
  - Copy the selected message
- Filter
  - Only display messages that are direct parents or children of the selected message
- New conversation
  - This is used to create a new conversation, a message at the root of the tree with no ancestry

## Updating Sprig

Simply follow the directions for [installing Sprig](#Installation) then just launch it. Feel free to delete the old binary if you wish.

## Going Further

Do you want to:

- **Report a bug?** Open a ticket in our [issue tracker](https://todo.sr.ht/~whereswaldon/arbor-dev)!
- **Give us some feedback?** Send us an email on our [mailing list](https://lists.sr.ht/~whereswaldon/arbor-dev)!
- **Get involved?** See our [home page](https://arbor.chat) for ways you can help our community (no code skills required)!
