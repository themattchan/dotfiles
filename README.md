### osx

```
setup.sh
```

### linux

either

```
sudo setup_arch.sh

sudo setup_fedora.sh
```

then

```
setup_linux.sh

setup.sh
```

### install nix provisioned software

```
curl https://nixos.org/nix/install | sh
cd nix; nix-env --file install.nix --install
```
