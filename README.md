## Guides

[Ubuntu Server](guides/ubuntu.md)

## Scripts

### Settings

[Git clear history](scripts/settings/git-clear-history.sh)

[Vim Nginx syntax](scripts/settings/vim-nginx-syntax.sh)

### Setups

[Configure Ubuntu Server](scripts/setups/ubuntu.sh)

[Install Docker](scripts/setups/docker.sh)

---

[Create Ubuntu Swap File (1Gb)](scripts/setups/swap-1g.sh)

[Create Ubuntu Swap File (2Gb)](scripts/setups/swap-2g.sh)

[Create Ubuntu Swap File (4Gb)](scripts/setups/swap-4g.sh)

[Create Ubuntu Swap File (8Gb)](scripts/setups/swap-8g.sh)

[Create Ubuntu Swap File (16Gb)](scripts/setups/swap-16g.sh)

[Create Ubuntu Swap File (32Gb)](scripts/setups/swap-32g.sh)

[Create Ubuntu Swap File (64Gb)](scripts/setups/swap-64g.sh)

---

## Bookmarks

### [JetBrains Toolbox App](https://www.jetbrains.com/toolbox-app/)

```
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
```

### [Node Version Manager](https://github.com/nvm-sh/nvm)

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
```

### [Oh My Zsh](https://ohmyz.sh/)

```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### [Homebrew](https://brew.sh/)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Tips

### Kill process on specific port

```
sudo kill -9 $(sudo lsof -t -i:8080)
```

### Generate SSH key

```
ssh-keygen -t rsa -b 4096 -C test@example.com
```
