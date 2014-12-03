use strict;
use warnings;
use utf8;
binmode STDOUT, 'utf8';

main() unless caller;

sub main {
  chomp( my $input = <STDIN> );
  if ( my $youbi_j = translate($input) ) {
    print "$input は $youbi_j です\n";
  } else {
    print "変換できませんでした\n";
  }
}

sub translate {
  my $str   = shift;
  my %youbi = (
    mon => '月曜日',
    tue => '火曜日',
    wed => '水曜日',
    thu => '木曜日',
    fri => '金曜日',
    sat => '土曜日',
    sun => '日曜日',
  );

  if ( exists $youbi{$str} ) {
    return $youbi{$str};
  } else {
    return;
  }
}
