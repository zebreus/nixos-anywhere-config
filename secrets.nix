{ lib, ... }:
with lib;
{
  options.modules.secretss = {
    coturn-static-auth-secret = mkOption {
      type = types.str;
      description = "Shared coturn secret";
    };
  };

  # The values of the secrets are stored in a separate file which is not part of this repository.
  imports = [
    /root/secrets.nix
  ];
}
