# ownyourday.ca

## What is this project?

ownyourday is a todo-list app with scheduling functionality for recurring tasks on a weekly basis.
I use this to keep myself accountable to my long term goals (weightlifting, running, reading) alongside allowing me to
add todos for myself on a day-to-day basis.

Moreover, developing and operating this application lets me experiment with new practices and hone what my existing techniques.

The application exists at [www.ownyourday.ca](https://ownyourday.ca/)

## Project dependencies
* `ruby` 3.1.2
* `node` 18 (local development only)
* `pnpm` to install javascript toolchain dev dependencies (local development only)
* `docker` for running postgres locally
* `make` for running commonly used commands via `Makefile`
* `postgres` for dependencies of the `pg` gem

You can either install these dependencies using your method of choice or leverage `nix` with `direnv`.

## How do I set up my dev environment?

### With Nix

Tentatively supporting using Nix to manage the developer environment. You will need `direnv` and `nix` installed on your machine.

See [this blog post](https://blog.testdouble.com/posts/2023-05-02-frictionless-developer-environments/) for a good explanation on how to set this up on your machine and why. 

If you're feeling lazy, the commands to run are:
```shell
# enable nix flakes
mkdir -p "$HOME/.config/nix"
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# install nix
sh <(curl -L https://nixos.org/nix/install)

# install direnv
nix profile install nixpkgs#direnv
echo 'eval "$(direnv hook zsh)"' >> "$HOME/.zshrc"

# then restart your shell and cd into the directory
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
