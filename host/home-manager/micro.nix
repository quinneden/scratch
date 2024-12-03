{
  pkgs,
  config,
  inputs,
  ...
}:
{
  xdg.configFile."micro/bindings.json".text = ''
    {
      "\u001b[1;2A": "SelectUp",
      "\u001b[1;2B": "SelectDown",
      "\u001b[1;2C": "SelectRight",
      "\u001b[1;2D": "SelectLeft",
      "\u001b[1;3D": "WordLeft",
      "\u001b[1;3C": "WordRight",
      "\u001b[1;3A": "MoveLinesUp",
      "\u001b[1;3B": "MoveLinesDown",
      "\u001b[1;4C": "SelectWordRight",
      "\u001b[1;4D": "SelectWordLeft",
      "\u001b[1;5D": "StartOfLine",
      "\u001b[1;5C": "EndOfLine",
      "\u001b[1;6D": "SelectToStartOfLine",
      "\u001b[1;2H": "SelectToStartOfLine",
      "\u001b[1;6C": "SelectToEndOfLine",
      "\u001b[1;2F": "SelectToEndOfLine",
      "\u001b[1;5A": "CursorStart",
      "\u001b[1;5H": "CursorStart",
      "\u001b[1;5B": "CursorEnd",
      "\u001b[1;5F": "CursorEnd",
      "\u001b[1;6H": "SelectToStart",
      "\u001b[1;6F": "SelectToEnd"
    }
  '';

  xdg.configFile."micro/settings.json".text = ''
    {
      "autoclose": true,
      "autosu": true,
      "colorscheme": "cuddles",
      "comment": true,
      "diff": true,
      "ftoptions": true,
      "initlua": true,
      "linter": true,
      "literate": true,
      "pluginchannels": [],
      "pluginrepos": [
        "https://github.com/quinneden/micro-autofmt/raw/refs/heads/main/repo.json"
      ],
      "parsecursor": true,
      "reload": "auto",
      "rmtrailingws": true,
      "saveundo": true,
      "tabhighlight": true,
      "tabsize": 2,
      "tabstospaces": true
    }
  '';

  home.file."micro-autofmt" = {
    recursive = true;
    target = "${config.xdg.configHome}/micro/plug/autofmt";
    source = inputs.micro-autofmt-nix.packages.${pkgs.system}.default;
  };

  home.file."micro-colors" = {
    recursive = true;
    target = "${config.xdg.configHome}/micro/colorschemes";
    source = inputs.micro-colors-nix.packages.${pkgs.system}.default;
  };
}
