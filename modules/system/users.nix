{ ... }: {

  flake.nixosModules.users = { ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."riccardo" = {
    isNormalUser = true;
    description = "Riccardo";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "passpass";
  };

  };

}



