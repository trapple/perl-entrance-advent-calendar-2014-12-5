# 超テスト入門 〜 サブルーチン復習とrequire, use

この記事は [Perl入学式 Advent Calendar 2014](http://qiita.com/advent-calendar/2014/perl-entrance) の 5日目です。

こんにちは。サポーターさせていただいてます まっすー（@trapple ）です。

今年のPerl入学式の進行具合ですと、第4回サブルーチン/正規表現が終わったり終わらなかったりな進行具合だと思います。
今回はそのサブルーチンをちょっと発展させた内容を書いてみます。

サブルーチンまだ習ってないよ！ or 忘れちゃったよ！って人はまずは[講義資料](https://github.com/perl-entrance-org/workshop-2014-04/blob/master/slide.md)に目を通してみてください。

## 復習問題

それでは簡単な復習問題からスタートします。

- mon, tue, wedといった3文字英語表記の曜日を引数として受け取り、月曜日, 火曜日, 水曜日といった日本語3文字表記の曜日を返すサブルーチンtranslate()を作ってください。
- 標準入力から受け取った文字列をtranslate()に渡し、mon ならば 「mon は 月曜日 です」tue ならば 「tue は 火曜日 です」といった出力をするプログラムを作ってください。七曜以外の文字を受け取った場合は「変換できませんでした」と出力しましょう。

#### 解答例は少しスクロール!
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## 解答例

```
use strict;
use warnings;
use utf8;
binmode STDOUT, 'utf8';

chomp( my $input = <STDIN> );
if ( my $youbi_j = translate($input) ) {
  print "$input は $youbi_j です\n";
} else {
  print "変換できませんでした\n";
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
```

主にこれまで習ったことだけで出来てるので、解説は必要なさそうです。

### テストする
講義では、このサブルーチンtranslate()が正しく実装できているかを確認するコードを書きましょう、といった追加問題がありました。これがいわゆるテストです。
ifを駆使して以下のような感じで書くことができますね。

```
if( translate('mon') eq '月曜日' ) {
  print "テストOK!\n";
}else{
  print "テスト...\n";
}
```

これがテストの基本的な考え方です。


## テストの発展

プログラミングの世界では、プログラムそのものと同じくらいテストが重要視される局面があります。
そのような需要に対応するために各言語それぞれテスト用の仕組みも充実しています。
PerlではTest::Moreというモジュールがそれになります。\*1

それではそのTest::Moreを使ってテストを書いてみましょう。

### テスト実行ファイルを作る

あらたにテスト実行用のファイル`youbi.t`を作ります。Perlの世界ではテストファイルの拡張子は`.t`とするのが一般的です。
そしてこのファイルに先ほどの`youbi.pl`を読み込んでみます。

```
# youbi.t
use strict;
use warnings;
use utf8;

require 'youbi.pl';
```

`require`関数 が初登場しました。この関数に読み込むファイル名を指定すると、そのファイルの内容が実行されます。その結果`youbi.t`の中で`translate()`が呼び出せるようになります。

それではシェルで`perl youbi.t`と打って実行してみましょう。

`perl youbi.pl`を実行した時と同じように標準入力の待機状態になりました。
このままではテストがしづらいので小細工をします。
再びyoubi.plに戻って以下のようにしてください。

[コード](https://gist.github.com/trapple/18b6d43355d8ae41c17c/b93494a0bafed8de9e0a12e118b4650609f7df69)

```
main() unless caller;

sub main {
  chomp(my $input = <STDIN>);
  if( my $youbi_j = translate($input) ) {
    print "$input は $youbi_j です\n";
  }else{
    print "変換できませんでした\n";
  }
}
```

translate()の定義以外の実行部分を新しいサブルーチンmain()として囲っています。
そしてそのサブルーチンをmain()で呼び出しているのですが、ここに`unless caller`という条件が入っています。
`caller`はPerlの組み込み関数で、現在の実行ファイルに対する、呼び出し元の情報を返します。
呼び出し元が無い場合は未定義値`undef`を返します。[日本語マニュアル](http://perldoc.jp/func/caller)

つまり`youbi.pl`が`youbi.t`から呼び出されている状態(テスト実行時)ならば、呼び出し元`youbi.t`の情報が返ってくるのでmain()は実行しない。
`perl youbi.pl`で実行していれば、呼び出し元は無いので`main()`も実行される。
といった具合になります。

これで心置きなくテストからtranslate()が呼び出せます。
試しにテスト側で`print translate('mon')`など書いてみましょう。

### Test::More を使う

次に`Test::More`を読み込んで使ってみましょう。`use Test::More;`を追加します。

```
# youbi.t
use strict;
use warnings;
use utf8;
use Test::More;

require 'calc.pl';
```

`use`は内部的には`require`と同じ処理＋αな機能を持ち、使い方の違いや初期化処理の追加などモジュール化を意識した作りになっています。

---

**{重要}**
PerlはCPANのモジュールを追加することで便利な機能を自由に追加できることはすでに説明があったとおもいますが、再利用や他人に使ってもらうことを意識したモジュールは、この`use`で使える形式で書く必要があります。
具体的には…

- 拡張子を`.pm`で作る。
- `package`を利用して名前空間を作る。
- （必要に応じて）オブジェクト指向で記述する。
- （必要に応じて）`exporter`を使ってサブルーチンをエクスポートする。
- `require`と`use`の違いを意識する。
- などなど

聞いたことがない用語が一気に出てしまったので、気になる人は調べてもらうことにしますが、
逆に言うと`youbi.pl`は`use`では読み込めない形式で書かれている = 再利用や他人に使ってもらうことをあまり考慮していないものだということを意識しておいてください。

例えば今回のケースで言うと、`translate()`の部分を切り出して、モジュール化して使うなどが考えられます。その話はまた次のステップとしておきます。
**{/重要}**

---

本題に戻って...
`Test::More`を読み込んだことによって色々な便利関数がインポートされています。その中から`is()`を使って今回のテストを組み立ててみましょう。
`is()`は`is($one, $two, $three)`と３つの引数を受け取ります。

- $oneはテストしたい値
- $twoはテスト結果として期待される値
- $threeはテストの名前（省略可能）

```
# youbi.t
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';
use Test::More;

require 'youbi.pl';

is( translate("mon"),  "月曜日", "mon => 月曜日" );

done_testing;
```
`use open ':std', ':encoding(utf8)';`は日本語を使いたい時に`use Test::More;`の前に書いてください。
`done_testing`はテストの終了を表す決まり文句としてつけるようにしてください。

__出力結果__

```
ok 1 - mon => 月曜日
1..1
```

okと出力されたらテスト成功です！
何個かテスト追記してみましょう。

```
is( translate("mon"),  "月曜日", "mon => 月曜日" );
is( translate("tue"),  "火曜日", "tue => 火曜日" );
is( translate("wed"),  "水曜日", "wed => 水曜日" );
is( translate("thu"),  "木曜日", "thu => 木曜日" );
is( translate("fri"),  "金曜日", "fri => 金曜日" );
is( translate("sat"),  "土曜日", "sat => 土曜日" );
is( translate("sun"),  "日曜日", "sun => 日曜日" );
is( translate("hoge"), undef,       "hoge => undef" );
```

__出力結果__

```
ok 1 - mon => 月曜日
ok 2 - tue => 火曜日
ok 3 - wed => 水曜日
ok 4 - thu => 木曜日
ok 5 - fri => 金曜日
ok 6 - sat => 土曜日
ok 7 - sun => 日曜日
ok 8 - hoge => undef
1..8
```

okが8つになりました。

[ここまでのコード](https://gist.github.com/trapple/e1dd23f88ee0310690c2/a7a26974cbc73142d440a082528c3ce8455df598)

## youbi.plの機能追加

ここでyoubi.plに機能を追加してみましょう。
内容は`translate()`の引数に渡す文字がmon以外に,MonでもMONでもよい、というものです。
せっかくテストを書いているので、先に期待されるテスト内容を書いてしまいましょう。

```
is( translate("Mon"),  "月曜日", "Mon => 月曜日" );
is( translate("MON"),  "月曜日", "MON => 月曜日" );
```

__出力結果__

```
ok 1 - mon => 月曜日
ok 2 - tue => 火曜日
ok 3 - wed => 水曜日
ok 4 - thu => 木曜日
ok 5 - fri => 金曜日
ok 6 - sat => 土曜日
ok 7 - sun => 日曜日
ok 8 - hoge => undef
not ok 9 - Mon => 月曜日
#   Failed test 'Mon => 月曜日'
#   at youbi.t line 18.
#          got: undef
#     expected: '月曜日'
not ok 10 - MON => 月曜日
#   Failed test 'MON => 月曜日'
#   at youbi.t line 19.
#          got: undef
#     expected: '月曜日'
1..10
# Looks like you failed 2 tests of 10.
```

当然ですがテストが通りません。`not ok`の部分です。期待される値は`月曜日`なのに`undef`が返ってますよ、とのことです。
ではこのテストが通るように`youbi.pl`を改良してみましょう。

#### 解答例は少しスクロール!
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
### 解答例

[コード](https://gist.github.com/trapple/18b6d43355d8ae41c17c/977542f96a2eacaab11b1db61a2f7eed2b7b98ae)

```
 if( exists $youbi{lc $str} ){
   return $youbi{lc $str};
 }else{
   return;
 } 
```
lcはPerlの組み込み関数で、大文字を小文字に変換します。
これでテストが通りました！
このように、以前のテスト結果をキープしつつ新機能のテストをすれば、機能追加やロジックの再考（リファクタリング）が安全確実に行えるのが、テストを書くメリットの1つだと言われています。

## 練習問題

- 標準入力からを`2014-12-5`といった日付を受け取り「2014-12-5 は 金曜日です」といった出力を返すプログラムに変更しましょう。
- 2014/12/5といった/を区切り文字にした日付も受け取れるようにしましょう。

### ヒント

Time::Pieceというモジュールを使ってみましょう。

### 解答例

[youbi.pl](https://github.com/trapple/perl-entrance-advent-calendar-2014-12-5/blob/2.0.0/youbi.pl)
[youbi.t](https://github.com/trapple/perl-entrance-advent-calendar-2014-12-5/blob/2.0.0/youbi.t)

こんな感じでしょうか？ポイントだけ説明しますと

#### `validate()`で入力チェックをする。
入力内容の確認については、正規表現だけで行うと結構難しいので、Time::Piece->strptimeのエラーを利用しました。
エラーを取得する `eval { hoge } if ($@) { fuga }` については[evalのドキュメント](http://perldoc.jp/func/eval)を参考にしてください。

#### `translate()`には何も変更をしない。
そのまま使えば良さそうだったので、このサブルーチンは変更がありません。
仮に変更がある場合は、内部ロジックの変更だけにとどめ出力は変わらないようにするのがベストでしょう。
テストはすでに書き終わっており実績があるので。
そうしないと、テストも全部書き直しになってしまいます（仕方ない場合もありますが）

以上、超テスト入門でした。
何かわからない部分などがあったらコメントに残してもらったり、Perl入学式に遊びに来ていただけると！
明日は・・・誰もいないですね。明後日はtomcha_さんです！


---
\*1 Test::More 以外にも[色々なテストモジュール](http://hirobanex.net/article/2012/08/1343880047)があります。それらを組み合わせるのが王道となっています。

---

## 参考リンク
[perl でテストを始めよう！！ - 2011 advent calendar test](http://perl-users.jp/articles/advent-calendar/2011/test/1)
[PerlでTDD(テスト駆動開発)するなら覚えておきたいCPANモジュール群 - hirobanex.net](http://hirobanex.net/article/2012/08/1343880047)
[Perl のテストについて(2011年改訂版1) - tsucchiの日記](http://d.hatena.ne.jp/tsucchi1022/20110410/1302395894)
[perl のモジュールインポートまわりの整理 - Please Sleep](http://please-sleep.cou929.nu/perl-module-loading-and-exporting.html)
[Perlで一枚岩のスクリプトをテスタブルにする - おそらくはそれさえも平凡な日々](http://www.songmu.jp/riji/entry/2014-08-14-test-perl-script.html)
[perl - $scalarの中身が数値か否かを判定する - 404 Blog Not Found](http://blog.livedoor.jp/dankogai/archives/50916183.html)
