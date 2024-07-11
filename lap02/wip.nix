{ home-manager, ... }:

{
  home-manager.users."jhollowe" = { pkgs, ... }: {
    home.packages = with pkgs; [ atool ];

    home.stateVersion = "24.05";
  };
}
