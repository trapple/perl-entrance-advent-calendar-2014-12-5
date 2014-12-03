use strict;
use warnings;
use utf8;
use Time::Piece;
binmode STDOUT, 'utf8';

main() unless caller;

sub main {
  print "日付を入力してください: ";
  chomp( my $input = <STDIN> );
  if ( my $t = validate($input) ) {
    print render($input, translate($t->day)), "\n";
  } else {
    print render(), "\n";
  }
}

sub translate {
  my $str = shift || return;
  my %youbi = (
    mon => '月曜日',
    tue => '火曜日',
    wed => '水曜日',
    thu => '木曜日',
    fri => '金曜日',
    sat => '土曜日',
    sun => '日曜日',
  );

  if ( exists $youbi{ lc $str } ) {
    return $youbi{ lc $str };
  } else {
    return;
  }
}

sub validate {
  my $str = shift || return;
  if ( $str =~ m!^(\d{1,4})[-/](\d{1,2})[-/](\d{1,2})$! ) {
    my $t;
    eval { $t = Time::Piece->strptime( "$1-$2-$3", '%Y-%m-%d' ); };
    if ($@) {
      return undef;
    }
    return $t;
  } else {
    return undef;
  }
}

sub render {
  my ( $input, $youbi_j ) = @_;
  if ($youbi_j) {
    return "$input は $youbi_j です";
  } else {
    return "変換できませんでした";
  }
}
