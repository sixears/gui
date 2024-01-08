{ pkgs }: pkgs.writers.writeBash "alac" ''
set -eu -o pipefail

id="$(${pkgs.coreutils}/bin/id --user)"
: ''${XDG_RUNTIME_DIR:=/run/user/$id}
export XDG_RUNTIME_DIR

exec >& "$XDG_RUNTIME_DIR/alac-$$.log"
TZ=UTC ${pkgs.coreutils}/bin/date +%Y-%m-%dZ%H:%M:%S
echo "PID: $$"
echo
echo '-- ENV --------------------------------'
${pkgs.coreutil}/bin/env --null | ${pkgs.coreutils}/bin/sort --zero-terminated | ${pkgs.coreutils}/bin/tr \\0 \\n
echo '---------------------------------------'
echo

alacritty=/home/martyn/.nix-profiles/x/bin/alacritty
byobu=/home/martyn/.nix-profiles/default/bin/byobu

config_file=$HOME/rc/alacritty/config.yml
term_name="$(wofi -d -L 1 -G)"

if [[ $term_name = '' ]]; then
  exec $alacritty --config-file $config_file --command $byobu new
else
  exec $alacritty --config-file $config_file --command $byobu new -A -t "$term_name"
fi
''

# Local Variables:
# mode: sh
# End:
