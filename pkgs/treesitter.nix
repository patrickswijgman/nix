# Symlink treesitter parsers (*.so) and its queries (*.scm) into one dir so
# they can be added to the Neovim runtime paths.

{
  lib,
  symlinkJoin,
  vimPlugins,
}:

let
  inherit (vimPlugins) nvim-treesitter nvim-treesitter-parsers;
  parsers = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter-parsers);
  queries = builtins.filter lib.isDerivation (builtins.attrValues nvim-treesitter.passthru.queries);
in
symlinkJoin {
  name = "treesitter";
  paths = parsers ++ queries;
}
