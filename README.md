# ownyourday.ca

## What is this project?

## Project dependencies
* `ruby` 3.1.2
* `node` 18 (local development only)
* `pnpm` to install javascript toolchain dev dependencies (local development only)
* `docker` for running postgres locally
* `make` for running commonly used commands via `Makefile`

### How do I set up my dev environment?

#### With Nix

Tentatively supporting using Nix to manage the developer environment. You will need `direnv` and `nix` installed on your machine.

To install both:
```shell
sh <(curl -L https://nixos.org/nix/install)
nix profile install nixpkgs#direnv
echo 'eval "$(direnv hook zsh)"' >> "$HOME/.zshrc"
```

Thereafter, on `cd`ing into the directory for the first time, run:
```shell
direnv allow
```

Upon subsequently entering the directory all project depenendencies should be present in your `PATH` as defined in the `flake.nix`

### Without direnv and Nix

The old fashioned way. Up to you to install the relevant dependencies using your preferred method of choice.

## How do I get it running on my machine?

* `bundler config build.pg --with-pg-config=$(which pg_config)`
  * Only required if you're using `nix`
  * This ensures we're using the `pg_config` specified in our `flake.nix` 
* `bundler`
* `pnpm install`
* `make up`
* Optional: `bin/rails db:create` and `bin/rails:db:migrate` if this is your first time running the app
* Optional: `make seed` if you want to seed a default user and its data
* `make serve`
* Optional: Login with `dev@example.com` and `Qweqwe1!`
