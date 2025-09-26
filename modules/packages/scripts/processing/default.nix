{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.scripts;
in {
  options.scripts = {
    motion_extraction.enable = lib.mkEnableOption "motion extraction fun";
    snapchat.enable = lib.mkEnableOption "Snapchat scripts";
  };

  config = {
    environment.systemPackages =
      lib.optionals cfg.motion_extraction.enable [
        (pkgs.writeShellScriptBin "extract_motion" ''
          ${pkgs.ffmpeg}/bin/ffmpeg -ss $2 -i $1 -i $1 -filter_complex "[1:v]negate[inv],[0:v][inv]blend=all_opacity=0.5:shortest=1" out.mp4
        '')
        (pkgs.writeShellScriptBin "highlight_motion" ''
          ${pkgs.ffmpeg}/bin/ffmpeg -ss $2 -i $1 -i $1 -filter_complex "[1:v]negate[inv],[0:v][inv]blend=all_mode='normal':all_opacity=0.5,eq=brightness=-0.5:contrast=7:eval=frame,gblur=steps=2:sigma=4,split [blr_out][blr],[0:v]eq=gamma=0.8[v1],[v1][blr]lut2=c0='x+(y)':c1='x':c2='x'[final]" -map '[blr_out]' blur.mp4 -map '[final]' out.mp4
        '')
      ]
      ++ lib.optionals cfg.snapchat.enable [
        (pkgs.writeShellScriptBin "snapchat_overlay" ''
          VIDEO=$(find . -name "*.mp4"); OVERLAY=$(find . -name "*.png" -or -name "*.webp"); ${pkgs.ffmpeg}/bin/ffmpeg -i $VIDEO -i $OVERLAY -filter_complex "[1:v][0:v]scale=width='ref_w':height='ref_h':force_original_aspect_ratio='disable'[scaled],[0:v][scaled]overlay" ../$VIDEO
        '')
      ];
  };
}
