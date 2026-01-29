{
  prepend_preloaders = [
    # Replace magick, image, video with mediainfo
    {
      mime = "{audio,video,image}/*";
      run = "mediainfo";
    }
    {
      mime = "application/subrip";
      run = "mediainfo";
    }
    # Adobe Illustrator; Adobe Photoshop is image/adobe.photoshop; already handled above
    {
      mime = "application/postscript";
      run = "mediainfo";
    }
  ];
  prepend_previewers = [
    # Replace magick; image; video with mediainfo
    {
      mime = "{audio,video,image}/*";
      run = "mediainfo";
    }
    {
      mime = "application/subrip";
      run = "mediainfo";
    }
    # Adobe Illustrator; Adobe Photoshop is image/adobe.photoshop; already handled above
    {
      mime = "application/postscript";
      run = "mediainfo";
    }
  ];
}
