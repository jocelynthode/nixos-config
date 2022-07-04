{
  programs.taskwarrior = {
    enable = true;
    config = {
      context.work.read = "+work";
      context.work.write = "+work";
      context.home.read = "+home";
      context.home.write = "+home";
    };
  };
}
