{ globals, ... }:

{
  programs.git = {
    enable = true;
    settings = {

      user.name = globals.GitName;
      user.email = globals.GitEmail;
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = "auto";
      # Use SSH instead of HTTPS for GitHub
      url."git@github.com:".insteadOf = "https://github.com/";
      commit.gpgSign = true;
      user.signingKey = "5888959633A5715A";
    };
  };
}
