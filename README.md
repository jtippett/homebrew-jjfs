# Homebrew Tap for jjfs

This repository contains the Homebrew formula for jjfs, an eventually consistent multi-mount filesystem using Jujutsu.

## Installation

```bash
# Install jjfs (taps automatically)
brew install jtippett/jjfs
```

Or tap first, then install:

```bash
brew tap jtippett/jjfs
brew install jjfs
```

## Usage

After installation:

```bash
# Install the daemon service
jjfs install

# Initialize a repo
jjfs init my-notes

# Open mounts
jjfs open my-notes ~/Documents/notes
jjfs open my-notes ~/Desktop/quick-notes
```

See the [main documentation](https://github.com/jtippett/jjfs) for more details.

## Updating

```bash
brew update
brew upgrade jjfs
```
