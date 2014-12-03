use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';
use Test::More;

require 'youbi.pl';

is( translate("mon"),  "月曜日", "Mon" );
is( translate("tue"),  "火曜日", "Tue" );
is( translate("wed"),  "水曜日", "Wed" );
is( translate("thu"),  "木曜日", "Thu" );
is( translate("fri"),  "金曜日", "Fri" );
is( translate("sat"),  "土曜日", "Sat" );
is( translate("sun"),  "日曜日", "Sun" );
is( translate("hoge"), undef,       "hoge" );

done_testing;
