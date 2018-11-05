## how to use nix

`nix` is a confusing and obtuse piece of shit but it does a passable job of
abstracting away the greater pain of configuring fiddly linux bullshit.

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

have to put

```
{ allowUnfree = true; }
```

in `~/.config/nixpkgs/config.nix`
