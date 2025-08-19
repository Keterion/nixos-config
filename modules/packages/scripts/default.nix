{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.scripts;
in {
  options.scripts = {
    motion_extraction.enable = lib.mkEnableOption "motion extraction fun";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.motion_extraction.enable [
      (pkgs.writeShellScriptBin "extract_motion" ''
        ${pkgs.ffmpeg} -ss $2 -i $1 -i $1 -filter_complex "[1:v]negate[inv],[0:v][inv]blend=all_opacity=0.5:shortest=1" out.mp4
      '')
      (pkgs.writeShellScriptBin "highlight_motion" ''
        ${pkgs.ffmpeg} -ss $2 -i $1 -i $1 -filter_complex "[1:v]negate[inv],[0:v][inv]blend=all_mode='normal':all_opacity=0.5,eq=brightness=-0.5:contrast=7:eval=frame,gblur=steps=2:sigma=4,split [blr_out][blr],[0:v]eq=gamma=0.8[v1],[v1][blr]lut2=c0='x+(y)':c1='x':c2='x'[final]" -map '[blr_out]' blur.mp4 -map '[final]' out.mp4
      '')
    ];
  };
}
