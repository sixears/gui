{ pkgs }: ''

grep=${pkgs.gnugrep}/bin/grep
sort=${pkgs.coreutils}/bin/sort

composes=( ${pkgs.xorg.libX11}/share/X11/locale/**/Compose )

grep_args=( --extended-regexp --invert-match --no-filename )

$grep "''${grep_args[@]}" $'^[ \t]*(#.*)?$' "''${composes[@]}" | $sort --unique
''

# Local Variables:
# mode: sh
# End:
