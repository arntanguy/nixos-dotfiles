{ globals, ... }:

{
  programs.git = {
    enable = true;
    settings = {

      user.name = globals.GitName;
      user.email = globals.GitEmail;
      init.defaultBranch = "main";
      rerere.enable = true;
      pull.rebase = true;
      color.ui = "auto";
      # Use SSH instead of HTTPS for GitHub
      url."git@github.com:".insteadOf = "https://github.com/";
      # GPG signing.
      # Export the corresponding public key with gpg --armor --export 5888959633A5715A > yubikey.pub
      commit.gpgSign = true;
      user.signingKey = "64DF9BCBF1C4E40520C8F7C22B2888B308742120";
    };
  };
}
