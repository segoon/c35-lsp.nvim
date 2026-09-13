# c35-lsp.nvim (deprecated)

> [!WARNING]
> This repository is deprecated and no longer maintained. Use
> [yaml-schema-selector.nvim](https://github.com/segoon/yaml-schema-selector.nvim)
> instead.

`yaml-schema-selector.nvim` is the modern replacement for this plugin. It
includes a built-in selector for Arcadia C35 `codegen-module.yaml` files and
integrates with `yaml-language-server` through its custom schema provider.

## Migration

Remove `segoon/c35-lsp.nvim` from your Neovim configuration and install the
replacement. For example, with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "segoon/yaml-schema-selector.nvim",
  ft = "yaml",
  config = function()
    require("yaml-schema-selector").setup()
  end,
}
```

No additional C35 selector registration is needed. The replacement requires
Neovim 0.11 or newer and an existing `yaml-language-server` configuration.
Its built-in C35 support also uses `arc`, `ya`, and the Python environment
provided by `ya tool tt python`.

The legacy implementation remains available in this archived repository for
existing users and historical reference.
