{ osConfig, ... }: 
with osConfig.system.colors; {
  font = osConfig.system.defaults.font.name;
  font-size = 12;
  text-color = "#${fg}";

  prompt-background = "#${bg}";
  prompt-background-padding = 0;
  prompt-background-corner-radius = 0;

  placeholder-color = "#${fg}";
  placeholder-background = "#${bg}";
  placeholder-background-padding = 0;
  placeholder-background-corner-radius = 0;

  input-background = "#${bg}";
  input-background-padding = 0;
  input-background-corner-radius = 0;

  default-result-background = "#${bg}";
  default-result-background-padding = 0;
  default-result-background-corner-radius = 0;

  selection-color = "#${purple}";
  selection-background = "#${bg}";
  selection-background-padding = 0;
  selection-background-corner-radius = 0;

  selection-match-color = "#${green}";

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

  background-color = "#${bg}";
  outline-width = 1;
  outline-color = "#${bg_dark}";
  border-width = 2;
  border-color = "#${blue1}";
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
}
