# home/programs/nixvim.nix
{ config, pkgs, lib, ... }:
let
  theme = config.horizon.theme;
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Dynamisches Theming basierend auf deinen Horizon-Skins
    extraConfigLua = if theme.ui.nixvim_transparent then ''
      vim.cmd [[highlight Normal guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight NormalNC guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight EndOfBuffer guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
    '' else ''
      vim.cmd [[highlight Normal guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
      vim.cmd [[highlight NormalNC guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
      vim.cmd [[highlight EndOfBuffer guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
    '';

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus";
      cursorline = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 50;
      # WICHTIG für render-markdown und neorg:
      conceallevel = 2; 
    };

    globals.mapleader = " ";

    plugins = {
      # 1. BLINK.CMP (Der neue Standard 2026)
      # Wir nutzen die stabile Version (v1), um Kompatibilitätsprobleme zu vermeiden.
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
        };
      };

      # 2. RENDER-MARKDOWN (Verschönert MD und Norg im Buffer)
      render-markdown = {
        enable = true;
        settings = {
          file_types = [ "markdown" "norg" ];
          latex.enabled = false;
        };
      };

      # 3. NEORG (Strukturierte Notizen mit MD-Export)
      neorg = {
        enable = true;
        modules = {
          "core.defaults".__empty = { };
          "core.concealer".__empty = { };
          # Automatischer Export nach Markdown beim Speichern
          "core.export".__empty = { };
          "core.export.markdown".__empty = { };
          "core.dirman".settings = {
            workspaces = {
              zentrale = "~/Development/Zentrale";
              horizon = "~/horizon/docs";
            };
            default_workspace = "zentrale";
          };
        };
      };

      # 4. LSP & TOOLS
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;      # Beste Nix-Integration
          ansiblels = {
            enable = true; # Für deine Pi-Konfiguration
            package = pkgs.ansible-language-server;
          };
          marksman.enable = true;  # LSP für Markdown
          bashls.enable = true;
        };
      };

      # 5. UI & NAVIGATION
      lualine.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      neo-tree.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
      
      # Git Integration
      gitsigns.enable = true;
      neogit.enable = true;
    };

    # Automatischer Direnv-Check beim Öffnen von Dateien
    extraConfigLuaPre = ''
      -- Verhindert das ständige manuelle "direnv allow" innerhalb von Neovim
      vim.g.direnv_silent_load = 1
    '';

    keymaps = [
      { action = "<cmd>Neotree toggle<CR>"; key = "<leader>e"; mode = "n"; options.desc = "Explorer"; }
      { action = "<cmd>Neogit<CR>"; key = "<leader>gg"; mode = "n"; options.desc = "Git"; }
      # Neorg Export Shortcut
      { action = "<cmd>Neorg export to-file<CR>"; key = "<leader>nx"; mode = "n"; options.desc = "Export Norg to MD"; }
    ];
  };
}
