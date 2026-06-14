# Symlink all treesitter parser files (*.so) and query files (*.scm) into a single directory.
# The nvim-treesitter plugin manages its own query files which contain specific improvements for the builtin treesitter in Neovim.

{
  lib,
  symlinkJoin,
  vimPlugins,
}:

let
  inherit (vimPlugins) nvim-treesitter-parsers nvim-treesitter;
  parsers = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter-parsers);
  queries = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter.passthru.queries);
in
symlinkJoin {
  name = "treesitter";
  paths = parsers ++ queries;
}
