_: {
  programs.nixvim.autoCmd = [
    {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    }
  ];
}
