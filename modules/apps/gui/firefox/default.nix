{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.apps.firefox;
in {
  options.apps.firefox = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.all.enable;
      type = lib.types.bool;
      description = "Whether to enable the firefox browser.";
    };
    arkenfox = lib.mkEnableOption "a profile configured with arkenfox";
    vim.enable = lib.mkEnableOption "vim navigation via tridactyl-vim";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name} = {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;

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
                  urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
                  icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.1fMdoHsa.svg";
                  definedAliases = ["@br"];
                };
              };
              force = true; # fixes the search.json.mozlz4 bug
            };
            bookmarks = {
              force = true;
              settings = [
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
            };
            extensions = {
              force = true;
              packages = with pkgs.nur.repos.rycee.firefox-addons;
                [
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
                ]
                ++ lib.optionals cfg.vim.enable [
                  pkgs.nur.repos.rycee.firefox-addons.tridactyl
                ];
              settings = {
                "uBlock@raymondhill.net".settings = {
                  selectedFilterLists = [
                    "ublock-filters"
                    "ublock-badware"
                    "ublock-privacy"
                    "ulock-unbreak"
                    "ublock-quick-fixes"
                  ];
                };
              };
            };
          };
          "SchizoMode" = lib.mkIf cfg.arkenfox {
            id = 1;
            search = {
              default = "Brave";
              engines = {
                "Brave" = {
                  urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
                  icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.1fMdoHsa.svg";
                  definedAliases = ["@br"];
                };
              };
              force = true; # fixes the search.json.mozlz4 bug
            };
            settings = {
              "browser.aboutConfig.showWarning" = false;
              "browser.startup.page" = 0;
              "browser.startup.homepage" = "about:blank";
              "browser.newtabpage.enabled" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.default.sites" = "";
              "geo.provider.ms-windows-location" = false;
              "geo.provider.use_corelocation" = false;
              "geo.provider.use_geoclue" = false;
              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.shopping.experience2023.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "app.shield.optoutstudies.enabled" = false;
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";
              "breakpad.reportURhttps://github.com/arkenfox/user.js/raw/refs/heads/master/user.jsL" = "";
              "browser.tabs.crashReporting.sendReport" = false;
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
              "captivedetect.canonicalURL" = "";
              "network.captive-portal-service.enabled" = false;
              "network.connectivity-service.enabled" = false;
              "browser.safebrowsing.downloads.remote.enabled" = false;
              "network.prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.dns.disablePrefetchFromHTTPS" = true;
              "network.predictor.enabled" = false;
              "network.predictor.enable-prefetch" = false;
              "network.http.speculative-parallel-limit" = 0;
              "browser.places.speculativeConnect.enabled" = false;
              "network.proxy.socks_remote_dns" = true;
              "network.file.disable_unc_paths" = true;
              "network.gio.supported-protocols" = "";
              "browser.urlbar.speculativeConnect.enabled" = false;
              "browser.urlbar.quicksuggest.enabled" = false;
              "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "browser.search.suggest.enabled" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.trending.featureGate" = false;
              "browser.urlbar.addons.featureGate" = false;
              "browser.urlbar.fakespot.featureGate" = false;
              "browser.urlbar.mdn.featureGate" = false;
              "browser.urlbar.pocket.featureGate" = false;
              "browser.urlbar.weather.featureGate" = false;
              "browser.urlbar.yelp.featureGate" = false;
              "browser.formfill.enable" = false;
              "browser.search.separatePrivateDefault" = true;
              "browser.search.separatePrivateDefault.ui.enabled" = true;
              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "network.auth.subresource-http-auth-allow" = 1;
              "browser.cache.disk.enable" = false;
              "browser.privatebrowsing.forceMediaMemoryCache" = true;
              "media.memory_cache_max_size" = 65536;
              "browser.sessionstore.privacy_level" = 2;
              "toolkit.winRegisterApplicationRestart" = false;
              "browser.shell.shortcutFavicons" = false;
              "security.ssl.require_safe_negotiation" = true;
              "security.tls.enable_0rtt_data" = false;
              "security.OCSP.enabled" = 1;
              "security.OCSP.require" = true;
              "security.cert_pinning.enforcement_level" = 2;
              "security.remote_settings.crlite_filters.enabled" = true;
              "security.pki.crlite_mode" = 2;
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_send_http_background_request" = false;
              "security.ssl.treat_unsafe_negotiation_as_broken" = true;
              "browser.xul.error_pages.expert_bad_cert" = true;
              "network.http.referer.XOriginTrimmingPolicy" = 2;
              "privacy.userContext.enabled" = true;
              "privacy.userContext.ui.enabled" = true;
              "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
              "media.peerconnection.ice.default_address_only" = true;
              "dom.disable_window_move_resize" = true;
              "browser.download.start_downloads_in_tmp_dir" = true;
              "browser.helperApps.deleteTempFileOnExit" = true;
              "browser.uitour.enabled" = false;
              "devtools.debugger.remote-enabled" = false;
              "permissions.manager.defaultsUrl" = "";
              "network.IDN_show_punycode" = true;
              "pdfjs.disabled" = false;
              "pdfjs.enableScripting" = false;
              "browser.tabs.searchclipboardfor.middleclick" = false;
              "browser.contentanalysis.enabled" = false;
              "browser.contentanalysis.default_result" = 0;
              "browser.download.useDownloadDir" = false;
              "browser.download.alwaysOpenPanel" = false;
              "browser.download.manager.addToRecentDocs" = false;
              "browser.download.always_ask_before_handling_new_types" = true;
              "extensions.enabledScopes" = 5;
              "extensions.postDownloadThirdPartyPrompt" = false;
              "browser.contentblocking.category" = "strict";
              "privacy.sanitize.sanitizeOnShutdown" = true;
              "privacy.clearOnShutdown_v2.cache" = true;
              "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
              "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
              "privacy.clearOnShutdown_v2.downloads" = true;
              "privacy.clearOnShutdown_v2.formdata" = true;
              "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
              "privacy.clearSiteData.cache" = true;
              "privacy.clearSiteData.cookiesAndStorage" = false;
              "privacy.clearSiteData.historyFormDataAndDownloads" = true;
              "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
              "privacy.clearSiteData.formdata" = true;
              "privacy.clearHistory.cache" = true;
              "privacy.clearHistory.cookiesAndStorage" = false;
              "privacy.clearHistory.historyFormDataAndDownloads" = true;
              "privacy.clearHistory.browsingHistoryAndDownloads" = true;
              "privacy.clearHistory.formdata" = true;
              "privacy.sanitize.timeSpan" = 0;
              "privacy.window.maxInnerWidth" = 1600;
              "privacy.window.maxInnerHeight" = 900;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "privacy.spoof_english" = 1;
              "browser.display.use_system_colors" = false;
              "widget.non-native-theme.use-theme-accent" = false;
              "browser.link.open_newwindow" = 3;
              "browser.link.open_newwindow.restriction" = 0;
              "extensions.blocklist.enabled" = true;
              "network.http.referer.spoofSource" = false;
              "security.dialog_enable_delay" = 1000;
              "privacy.firstparty.isolate" = false;
              "extensions.webcompat.enable_shims" = true;
              "security.tls.version.enable-deprecated" = false;
              "extensions.webcompat-reporter.enabled" = false;
              "extensions.quarantinedDomains.enabled" = true;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";
              "browser.startup.homepage_override.mstone" = "ignore";
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "browser.urlbar.showSearchTerms.enabled" = false;
            };
          };
        };
      };
    };
  };
}
