use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';
use Test::More;

require 'youbi.pl';

subtest 'translate', sub {
  is( translate("mon"),  "月曜日", "mon => 月曜日" );
  is( translate("tue"),  "火曜日", "tue => 火曜日" );
  is( translate("wed"),  "水曜日", "wed => 水曜日" );
  is( translate("thu"),  "木曜日", "thu => 木曜日" );
  is( translate("fri"),  "金曜日", "fri => 金曜日" );
  is( translate("sat"),  "土曜日", "sat => 土曜日" );
  is( translate("sun"),  "日曜日", "sun => 日曜日" );
  is( translate("hoge"), undef,       "hoge => undef" );
  is( translate(undef),  undef,       "undf => undef" );

  is( translate("Mon"), "月曜日", "Mon => 月曜日" );
  is( translate("MON"), "月曜日", "MON => 月曜日" );
  is( translate("MoN"), "月曜日", "MoN => 月曜日" );
  is( translate("Wed"), "水曜日", "Wed => 水曜日" );

};

subtest 'validate', sub {
  is( validate(undef),         undef, 'validation fail' );
  is( validate('hoge'),        undef, 'validation fail' );
  is( validate('99999-10-10'), undef, 'validation fail' );
  is( validate('0120-10-10'),  undef, 'validation fail' );
  is( validate('1989-0-10'),   undef, 'validation fail' );
  is( validate('1989-13-10'),  undef, 'validation fail' );
  is( validate('1989-12-99'),  undef, 'validation fail' );
  isa_ok( validate('1977-2-26'), 'Time::Piece', 'validation ok' );
  isa_ok( validate('1900-1-1'),  'Time::Piece', 'validation ok' );
  isa_ok( validate('9999-1-1'),  'Time::Piece', 'validation ok' );
  isa_ok( validate('2014/12/5'),  'Time::Piece', 'validation ok' );
};

subtest 'render', sub {
  is( render( '2014-12-5', '金曜日' ), "2014-12-5 は 金曜日 です", "render normal" );
  is( render( 'hoge',      'fuga' ),      "hoge は fuga です",           "render normal" );
  is( render( 'hoge',      undef ),       "変換できませんでした", "render invalid" );
  is( render(), "変換できませんでした", "render invalid" );
};

done_testing;
