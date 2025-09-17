{ config, pkgs, inputs, flakeSettings, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        lsp.enable = true;
        git.enable = true;

        options = {
          shiftwidth = 2;
          tabstop = 2;
        };

        globals = {
          mapleader = ";";
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nix.enable = true;
          python.enable = true;
          bash.enable = true;
          sql.enable = true;
          markdown.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          ts = {
            enable = true;
            format.type = "biome";
          };
          html = {
            enable = true;
          };
          css = {
            enable = true;
            format.type = "biome";
          };
          assembly.enable = true;
          clang.enable = true;
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "nord";
          };
        };

        theme = {
          enable = true;
          name = "nord";
          #style = "dark";
          transparent = true;
        };

        autopairs.nvim-autopairs.enable = true;

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          modes-nvim.enable = true;
        };

        utility = {
          yanky-nvim = {
	    enable = true;
            setupOpts.ring.storage = "sqlite";
          };
          undotree.enable = true;
#          icon-picker.enable = true;
        };

	gestures = {
          gesture-nvim.enable = true;
	};

        autocomplete.nvim-cmp.enable = true;
        dashboard.dashboard-nvim.enable = true;
        filetree.neo-tree.enable = true;
#        statusline.lualine.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
        utility.motion.leap.enable = true;
      };
    };
  };
}
