use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';
use Test::More;

require 'youbi.pl';

is( translate("mon"),  "月曜日", "mon => 月曜日" );
is( translate("tue"),  "火曜日", "tue => 火曜日" );
is( translate("wed"),  "水曜日", "wed => 水曜日" );
is( translate("thu"),  "木曜日", "thu => 木曜日" );
is( translate("fri"),  "金曜日", "fri => 金曜日" );
is( translate("sat"),  "土曜日", "sat => 土曜日" );
is( translate("sun"),  "日曜日", "sun => 日曜日" );
is( translate("hoge"), undef,       "hoge => undef" );

is( translate("Mon"),  "月曜日", "Mon => 月曜日" );
is( translate("MON"),  "月曜日", "MON => 月曜日" );
is( translate("MoN"),  "月曜日", "MoN => 月曜日" );
is( translate("Wed"),  "水曜日", "Wed => 水曜日" );

done_testing;
