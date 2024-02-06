{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    trusted-substituters = "https://devenv.cachix.org";
    extra-trusted-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {

                  #packages = [ pkgs.elixir ]
                  languages.elixir.enable = true;
                  languages.erlang.enable = true;

                  enterShell = ''
                    export PS1='\n\[\033[1;32m\][nix-shell:\w]($(git rev-parse --abbrev-ref HEAD))\$\[\033[0m\] '

                    # this allows mix to work on the local directory
                    mkdir -p .nix-mix
                    mkdir -p .nix-hex
                    export MIX_HOME=$PWD/.nix-mix
                    export HEX_HOME=$PWD/.nix-hex
                    export PATH=$MIX_HOME/bin:$PATH
                    export PATH=$HEX_HOME/bin:$PATH
                    export LANG=en_US.UTF-8

                    export ERL_AFLAGS="-kernel shell_history enabled"
                  '';

                }
              ];
            };
          });
      };
}
