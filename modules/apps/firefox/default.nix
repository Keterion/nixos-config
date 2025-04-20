{ pkgs, config, lib, ...}:
let
  cfg = config.apps.firefox;
in {
  options.apps.firefox = {
    enable = lib.mkEnableOption "the firefox browser";
    arkenfox = lib.mkEnableOption "a profile configured with arkenfox";
    vim.enable = lib.mkEnableOption "vim navigation via tridactyl-vim";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      arkenfox = {
	enable = cfg.enable;
	version = "128.0";
      };

      profiles = {
        "default" = {
	  id = 0;
          settings = {
            "extensions.autoDisableScopes" = 0;
	    "browser.startup.page" = 3;
	    "browser.search.region" = "US";
	    "browser.eme.ui.enabled" = true;
	    "browser.eme.enabled" = true;
	    
	    "privacy.sanitize.sanitizeOnShutdown" = true; # perform Clear Private Data on exit # you stole all my history and tabs even with disabled history clear??
	    "privacy.item.cookies" = true; # Clear Private Data deletes cookies
	    "privacy.item.history" = false; # Clear Private Data deletes history
          };
	  search = {
	    default = "Brave";
	    engines = {
	      "Brave" = {
	        urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
		icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.1fMdoHsa.svg";
		definedAliases = [ "@br" ];
	      };
	    };
	    force = true; # fixes the search.json.mozlz4 bug
	  };
	  bookmarks = [
	    {
	      name = "Toolbar";
	      toolbar = true;
	      bookmarks = [
	        {
	          name = "Hosted"; # auto-add to this group
	          toolbar = false;
	          bookmarks = [
		    {
		      name = "Syncthing";
	              url = "localhost:8384";
		    }
	          ];
	        }
	      ];
	    }
	    {
	      name = "Nix sites";
	      toolbar = false;
	      bookmarks = [
	        #{
		#  name = "myNix";
		#  url = "https://mynixos.com";
		#}
		{
		  name = "Noogle";
		  url = "https://noogle.dev";
		}
		{
		  name = "Home Manager - Option Search";
		  url = "https://home-manager-options.extranix.com";
		}
		{
		  name = "NueschOS Search";
		  url = "https://search.nüschtos.de";
		}
		{
		  name = "Searchix";
		  url = "https://searchix.alanpearce.eu";
		}
		{
		  name = "pkgs search";
		  url = "https://search.nixos.org/packages";
		}
	      ];
	    }
	  ];
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            privacy-badger
            fastforwardteam
            search-by-image
            ublock-origin
            tampermonkey
            noscript
	    libredirect
            darkreader
            #dictionaries
	    sidebery
	    #omnivore
	    #lexicon
            #buildFirefoxXpiAddon { #TODO
            #  pname = "imagus-mod";
            #  version = "0.10.15";
            #  addonId = "6833a9cb-d329-4d96-a062-76b1b663cd2c";
            #  url = "https://addons.mozilla.org/firefox/downloads/file/4170790/imagus_mod-0.10.15.xpi";
            #  meta = with lib; {
            #    homepage = "https://prod.outgoing.prod.webservices.mozgcp.net/v1/be14a87f1d00256c0532612c960861e8d8aa6adca6d9e62dcd35a8a30d9096fc/https%3A//github.com/TheFantasticWarrior/chrome-extension-imagus";
            #    description = "With a simple mouse-over you can enlarge and display images/videos from links. Now with optional permissions, more features.";
            #    license = licenses.bsd2;
            #    mozPermissions = [
            #      "<all_urls>"
            #      "history"
            #      "downloads"
            #    ];
            #    platforms = platforms.all;
            #  };
            #}
          ] ++ lib.optionals cfg.vim.enable [
	    pkgs.nur.repos.rycee.firefox-addons.tridactyl-vim
	  ];
        };
	"SchizoMode" = lib.mkIf config.modules.apps.firefox.arkenfox {
	  id = 1;
	  search = {
	    default = "Brave";
	    engines = {
	      "Brave" = {
	        urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
		icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.1fMdoHsa.svg";
		definedAliases = [ "@br" ];
	      };
	    };
	    force = true; # fixes the search.json.mozlz4 bug
	  };
	  arkenfox = {
	    enable = true;
	    "0000".enable = true; # Introduction
	    "0100" = {
	      # STARTUP
	      enable = true;
	    };
	    "0200" = {
	      # GEOLOCATION
	      enable = true;
	    };
	    "0300" = {
	      # QUIETER FOX
	      enable = true;
	    };
	    "0400" = {
	      # SAFE BROWSING (SB)
	      enable = true;
	      "0403"."browser.safebrowsing.downloads.remote.enabled".value = true; # enable SB checks for downloads (verify downloaded executables with google servers)
	    };
	    "0600" = {
	      # BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on]
	      enable = true;
	    };
	    "0700" = {
	      # DNS / DoH / PROXY / SOCKS
	      enable = true;
	    };
	    "0800" = {
	      # LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
	      enable = true;
	    };
	    "0900" = {
	      # PASSWORDS
	      enable = true;
	    };
	    "1000" = {
	      # DISK AVOIDANCE
	      enable = true;
	    };
	    "1200" = {
	      # HTTPS (SSL/TLS / OCSP / CETRS / HPKP)
	      enable = true;
	    };
	    "1600" = {
	      # REFERERS
	      enable = true;
	    };
	    "1700" = {
	      # CONTAINERS
	      enable = true;
	    };
	    "2000" = {
	      # PLUGINS / MEDIA / WEBRTC
	      enable = true;
	    };
	    "2400" = {
	      # DOM (DOCUMENT OBJECT MODEL)
	      enable = true;
	    };
	    "2600" = {
	      # MISCELLANEOUS
	      enable = true;
	    };
	    "2700" = {
	      # ETC (ENHANCED TRACKING PROTECTION)
	      enable = true;
	    };
	    "2800" = {
	      # SHUTDOWN & SANITIZING
	      enable = true;
	    };
	    "4000" = {
	      # FPP (fingerprintingProtection)
	      enable = true;
	    };
	    "4500" = {
	      # OPTIONAL RFP (resistFingerprinting)
	      enable = true;
	    };
	    "5000" = {
	      # OPTIONAL OPSEC
	      enable = true;
	    };
	    "5500" = {
	      # OPTIONAL HARDENING
	      enable = true;
	    };
	    "6000" = {
	      # DON'T TOUCH
	      enable = true;
	    };
	    "7000" = {
	      # DON'T BOTHER
	      enable = true;
	    };
	    "8000" = {
	      # DON'T BOTHER: FINGERPRINTING
	      enable = true;
	    };
	    "9000" = {
	      # NON-PROJECT RELATED
	      enable = true;
	    };
	  };
	};
      };
    };
  };
}
