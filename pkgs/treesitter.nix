{
  lib,
  symlinkJoin,
  vimPlugins,
}:

# Symlink all treesitter parsers and query files into a single directory.
# Parsers come from `vimPlugins.nvim-treesitter-parsers.<name>`, queries from `vimPlugins.nvim-treesitter.passthru.queries.<name>`.
let
  inherit (vimPlugins) nvim-treesitter-parsers nvim-treesitter;
  parsers = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter-parsers);
  queries = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter.passthru.queries);
in
symlinkJoin {
  name = "treesitter";
  paths = parsers ++ queries;
}
