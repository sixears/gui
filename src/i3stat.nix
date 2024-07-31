{ pkgs, i3status-rc, swap-summary-fifo, cpu-temp-fifo, replace }:
pkgs.writers.writeBashBin "i3stat" ''

cat=${pkgs.coreutils}/bin/cat
i3status=${pkgs.i3status}/bin/i3status
id=${pkgs.coreutils}/bin/id
replace=${replace}/bin/replace

uid=$($id --user)

swap_summary_fifo=${swap-summary-fifo}
cpu_temp_fifo=${cpu-temp-fifo}

replace_cmd=( $replace __swap-summary-fifo__ "$swap_summary_fifo"
                       __cpu-temp-fifo__     "$cpu_temp_fifo"     )

i3status_rc=${i3status-rc}/share/i3status.rc
exec $i3status -c <( "''${replace_cmd[@]}" < $i3status_rc ) \
                2> /run/user/$uid/i3stat.log
''

# Local Variables:
# mode: sh
# End:
