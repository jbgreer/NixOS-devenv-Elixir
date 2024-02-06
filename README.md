# NixOS devenv Elixir environment

Uses devenv Elixir language and shell to setup a basic environment.
Works well with direnv

To use this with Elixir
```
  $ git clone <this>        # where <this> is the path of this repository
  $ cd <this>
  $ devenv init
  $ rm  -rf .git            # to avoid nested respositories later on
  $ mix new <project>       # create new project
```

Note: if you're creating a new project, you'll probably want to run mix local.hex

To update this flake,
```
    $ nix flake update --accept-flake-config
```

The flag tells nix to trust the additional substituter.

