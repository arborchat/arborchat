---
title: Hosting your own arbor relay
---

# Acquiring the relay

We don't currently have pre-built binaries for the relay, but you can build it yourself very easily. You need a recent version of [`go`](https://golang.org/dl) and `git`.

```sh
git clone https://git.sr.ht/~whereswaldon/sprout-go
cd sprout-go/cmd/relay
go build
```

At the end of this, there will be an executable in the current working directory named `relay`. For convenience, you can move this into your `$PATH` like so:

```sh
sudo mv -v ./relay /usr/local/bin/
```

This will likely require sudo. You can also copy the relay anywhere else in your `$PATH`, like `~/.local/bin`.

# Setting up TLS certificates

The relay requires TLS certificates because it only serves TLS traffic right now. This may change in the future. You can easily create local certificates with [`mkcert`](https://github.com/FiloSottile/mkcert).

```sh
mkcert -install
mkcert example.test localhost 127.0.0.1 ::1
```

The above will put two files in your current working directory. The private key ends with `key.pem`, whereas the public key doesn't have the word key in its name.

For real certificates, you can acquire some pretty quickly by setting up an installation of [`caddy`](https://caddyserver.com/) for your domain. Caddy automatically provisions TLS certificates from Let's Encrypt, and you can just hand those to your relay. They do expire after 90 days, so you'll need to restart your relay periodically when taking this approach.

# Seeding your grove with a community

A relay is useless without at least one community. Your relay will keep all of its arbor data in a directory called a "grove", and we must provide a community in that directory for the relay to host. There are several ways to do this.

Before creating a community, we need to do two things:

- Create a directory to store the grove in with `mkdir grove` (you can put this wherever you want).
- Install the `forest` CLI (required for two of the three options below).

## Installing the forest CLI

```sh
git clone https://git.sr.ht/~whereswaldon/forest-go
cd forest-go/cmd/forest
go build
sudo mv ./forest /usr/local/bin
```

## Copying your history from sprig

If you already run sprig somewhere and you'd like to continue using the same communities and user identity that you already have in sprig, you can just copy them to your relay:

```sh
cp -R "$HOME/.config/sprig/grove" "grove"
```

This assumes that your new grove directory is in the current working directory.

## Creating a new community with your sprig identity

If you want to keep your user account from sprig and use it to create a new community, simply do this:

```sh
identity=$(ls ~/.config/sprig/identities/ | head -n1)
community=$(forest create community --as "~/.config/sprig/identities/$identity" --key "~/.config/sprig/keys/$identity" --name <name>)
mv -v "~/.config/sprig/identities/$identity" "$community" grove/
```

Replace `<name>` with the name of your new community. This assumes your new grove directory is in the current working directory.

## Creating a new identity and a new community

If you want to create a completely new arbor identity and use that to start a community, you can do this:

```sh
identity=$(forest create identity --name <username>)
community=$(forest create community --as "$identity" --name <name>)
cp -v "$identity" grove/
mv -v "$community" grove/
```

This will leave your new identity and the corresponding private key in the current working directory, while also putting the necessary node files into the grove. You can save that identity and private key for later use, though sprig doesn't currently have an easy way to import these (you can change identities by manually editing the configuration though).

# Starting your relay

Once you have gotten TLS certificates and set up your grove, starting a relay is easy:

```sh
relay --certpath <tls-certificate-pem> --keypath <tls-key-pem> --grovepath <path-to-grove>
```

This will start a relay listening on `localhost:7777`. You can change the listening IP and port with the `--tls-ip` and `--tls-port` flags.

# Connecting with sprig

Often, if you're setting up a testing relay, you won't want to connect with your normal sprig application. This risks getting test data mixed into your real conversations, or even sending your test data to other users accidentally. Sprig has an easy feature to help with this. To start sprig with an entirely clean configuration, run it like this:

```sh
sprig --data-dir=$(mktemp -d)
```

You can specify any directory you want (so long as it isn't `~/.config/sprig`) to ensure that you don't mix your normal sprig data and your test data.

Once sprig starts, specify `localhost:7777` as the relay address to connect to your local relay. If you set your relay up with a proper domain name, use that instead.
