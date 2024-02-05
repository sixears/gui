{ pkgs, i3status-rc }: pkgs.writers.writeBashBin "i3stat" ''

cat=${pkgs.coreutils}/bin/cat
i3status=${pkgs.i3status}/bin/i3status

exec $i3status -c <($cat ${i3status-rc}/share/i3status.rc)
''

# Local Variables:
# mode: sh
# End:
