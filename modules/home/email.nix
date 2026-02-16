{ inputs, config,... }: {
  accounts.email = {
    accounts."arn.tanguy@gmail.com" = {
      thunderbird.enable = true;
      address = "arn.tanguy@gmail.com";
      flavor = "gmail.com";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      userName = "arn.tanguy@gmail.com";
      primary = true;
      realName = "Arnaud Tanguy";
      # No passwordCommand!
      signature = {
        text = ''
          Arnaud Tanguy
        '';
        showSignature = "append";
      };
    };
    accounts."equipe.magh@gmail.com" = {
      thunderbird.enable = true;
      address = "equipe.magh@gmail.com";
      flavor = "gmail.com";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      userName = "equipe.magh@gmail.com";
      primary = false;
      realName = "Groupe Promotion Alpinisme FFCAM MAGH (Montagne Alpinisme Groupe Herault)";
      # No passwordCommand!
      signature = {
        text = ''
        Groupe Promotion Alpinisme FFCAM MAGH (Montagne Alpinisme Groupe Herault)
        '';
        showSignature = "append";
      };
    };
    accounts."arnaud.tanguy@lirmm.fr" = {
      thunderbird.enable = true;
      address = "arnaud.tanguy@lirmm.fr";
      flavor = "plain";
      imap = {
        host = "imap.lirmm.fr";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      smtp = {
        host = "smtp.lirmm.fr";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      userName = "atanguy";
      primary = false;
      realName = "Arnaud Tanguy";
      signature = {
        text = ''
          Arnaud Tanguy
          LIRMM
        '';
        showSignature = "append";
      };
    };
    accounts."arnaud.tanguy@umontpellier.fr" = {
      thunderbird.enable = true;
      address = "arnaud.tanguy@umontpellier.fr";
      flavor = "plain";
      imap = {
        host = "imap.umontpellier.fr";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };
      smtp = {
        host = "smtp.umontpellier.fr";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      userName = "arnaud.tanguy@umontpellier.fr";
      primary = false;
      realName = "Arnaud Tanguy";
      signature = {
        text = ''
          Arnaud Tanguy
          Université de Montpellier
        '';
        showSignature = "append";
      };
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles = {
      "arn.tanguy@gmail.com".isDefault = true;
    };
  };
}
