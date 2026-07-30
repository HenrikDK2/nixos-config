{
  programs.fish = {
    enable = true;

    shellAliases = {
      ns = "sudo nixos-rebuild switch -I nixos-config=$HOME/nixos/configuration.nix";
      nb = "sudo nixos-rebuild switch -I nixos-config=$HOME/nixos/configuration.nix";
    };
  };
}
