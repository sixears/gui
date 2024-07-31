{ pkgs }: ''

# dump out all the valid xkb keysyms

# Pragma ------------------------------

use 5.30.0;
use strict;
use warnings;

my $keysymdef_h = '${pkgs.xorg.xorgproto}/include/X11/keysymdef.h';
open my $fh, '<', $keysymdef_h
  or die "failed to open '$keysymdef_h': $!";
while (<$fh>) {
  chomp;

  if ( my ($n,$c) = m!^#define\s+XK_(\S+)\s.*?(?:/\*\s*(\S.*\S)\s*\*/)?\s*$! ) {
    if ( ($c//"") !~ /^\s*$/ ) {
      printf "%-32s\t# %s\n", $n, $c;
    } else {
      say $n;
    }
  }
}
''

# Local Variables:
# mode: perl
# End:
