# NixOS Configuration

Clone this repository into your home directory:

```bash
git clone https://github.com/HenrikDK2/nixos-config $HOME/nixos
```

Apply the configuration with:

```bash
sudo nixos-rebuild switch -I nixos-config=$HOME/nixos/configuration.nix
```

Whenever you make changes to `configuration.nix` or other imported files, run the same command again to rebuild and apply the updated configuration.
