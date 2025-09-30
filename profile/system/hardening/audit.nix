{ lib, ... }:

let
  rulesFileContent = builtins.readFile ./audit.rules;
in
{
  security.auditd.enable = lib.mkDefault false;
  security.audit = {
    enable = lib.mkDefault false;
    rules =
      let
        lines = lib.strings.splitString "\n" rulesFileContent;
      in
      builtins.filter (line: (!lib.strings.hasPrefix "#" line) && line != "") lines;
  };
}
