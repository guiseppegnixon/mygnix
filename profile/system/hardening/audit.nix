{ lib, ... }:

let
  rulesFileContent = builtins.readFile ./audit.rules;
in
{
  security.auditd.enable = lib.mkDefault true;
  security.audit = {
    enable = lib.mkDefault true;
    rules =
      let
        lines = lib.strings.splitString "\n" rulesFileContent;
      in
      builtins.filter (line: (!lib.strings.hasPrefix "#" line) && line != "") lines;
  };
}
