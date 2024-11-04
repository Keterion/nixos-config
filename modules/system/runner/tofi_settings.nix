{ ... }: {
  programs.tofi.settings = {
      font = "Hack Nerd Font Mono";
      font-size = 12;
      text-color = "#c8d3f5";
      
      prompt-background = "#222436";
      prompt-background-padding = 0;
      prompt-background-corner-radius = 0;
      
      placeholder-color = "#c8d3f5a8";
      placeholder-background = "#00000000";
      placeholder-background-padding = 0;
      placeholder-background-corner-radius = 0;
      
      input-background = "#00000000";
      input-background-padding = 0;
      input-background-corner-radius = 0;
      
      default-result-background = "#00000000";
      default-result-background-padding = 0;
      default-result-background-corner-radius = 0;
      
      selection-color = "#c099ff";
      selection-background = "#2f334d00";
      selection-background-padding = 0;
      selection-background-corner-radius = 0;
      
      selection-match-color = "#c3e88d";
      
      text-cursor-style = "bar";
      text-cursor-corner-radius = 0;
      
      prompt-text = "run: ";
      prompt-padding = 0;
      placeholder-text = "Search...";
      
      num-results = 0;
      result-spacing = 0;
      horizontal = false;
      min-input-width = 0;
      
      width = "25%";
      height = "25%";
      
      background-color = "#222436";
      outline-width = 1;
      outline-color = "#1e2030";
      border-width = 2;
      border-color = "#86e1fc";
      corner-radius = 3;
      padding-top = 8;
      padding-bottom = 8;
      padding-left = 8;
      padding-right = 8;
      
      clip-to-padding = true;
      scale = true;
      
      #output = "";
      anchor = "center";
      exclusive-zone = -1;
      
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      
      hide-cursor = false;
      text-cursor = true;
      history = true;
      
      #matching-algorithm = "normal";
      require-match = true;
      auto-accept-single = false;
      hide-input = false;
      hidden-character = "*";
      #physical-keybindings = true;
      
      #print-index = false;
      
      drun-launch = true;
      
      multi-instance = false;
      ascii-input = false;
  };
}
