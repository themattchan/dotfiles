## how to use nix

`nix` is a confusing and obtuse piece of shit but it does a passable job of
abstracting away the greater pain of configuring fiddly linux bullshit.

setup nixos:

blow out the contents of `/etc/nixos/configuration.nix`, and add the following to the `imports` section of that file:

```
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/matt/dotfiles/nix/configuration.nix
    ];
```

install it all

```
nix-env --install --file install.nix
```

install a specific section

```
nix-env --install --file install.nix --attr <name>
```

show installed

```
nix-env -q
```

## !!! IMPORTANT

on a non-nixos install, have to put

```
{ allowUnfree = true; }
```

in `~/.config/nixpkgs/config.nix`
