//
// Zigには数学的演算のための組み込み関数があります。例えば...
//
//      @sqrt        @sin           @cos
//      @exp         @log           @floor
//
// ...そして多くの型キャスト演算があります。例えば...
//
//      @as          @errorFromInt  @floatFromInt
//      @ptrFromInt  @intFromPtr    @intFromEnum
//
// 雨の日の一部を公式Zigドキュメントの組み込み関数一覧を
// ざっと読むのに使っても時間の無駄にはならないでしょう。
// 本当にクールな機能があります。@call、@compileLog、
// @embedFile、@src などを確認してみてください！
//
//                            ...
//
// 今は、Zigの多くのイントロスペクション能力のうち
// たった3つを探ることで組み込み関数の調査を完了します：
//
// 1. @This() type
//
// 関数呼び出しが内側にある最もネストされた
// struct、enum、またはunionを返します。
//
// 2. @typeInfo(comptime T: type) @import("std").builtin.Type
//
// 任意の型についての情報を、調べている型によって
// 異なる情報を含むデータ構造で返します。
//
// 3. @TypeOf(...) type
//
// すべての入力パラメータ（それぞれが任意の式になりえます）に
// 共通の型を返します。型はコンパイラ自体が型を推論する際に
// 使う「ピア型解決」プロセスと同じものを使って解決されます。
//
// （型を返す2つの関数が大文字で始まることに気づきましたか？
// これはZigの標準的な命名規則です。）
//
const print = @import("std").debug.print;

const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined, // ああ、可哀想なEcho！

    fn fetchTheMostBeautifulType() type {
        return @This();
    }
};

pub fn main() void {
    var narcissus: Narcissus = Narcissus{};

    // おっと！'me'と'myself'フィールドを
    // undefinedのままにしておくことはできません。
    // ここで設定してください：
    narcissus.me = &narcissus;
    narcissus.myself = &narcissus;

    // 3つの別々の参照（たまたますべて同じオブジェクトです）から
    // 「ピア型」を決定します。
    const Type1 = @TypeOf(narcissus, narcissus.me.*, narcissus.myself.*);

    // まずいことをしてしまったようです。この関数を
    // メソッドとして呼び出しましたが、selfパラメータが
    // ありません。（上記参照。）
    //
    // この修正は非常に微妙ですが、大きな違いをもたらします！
    const Type2 = Narcissus.fetchTheMostBeautifulType();

    // Narcissusについての気の利いた文を出力します。
    print("A {s} loves all {s}es. ", .{
        maximumNarcissism(Type1),
        maximumNarcissism(Type2),
    });

    //   彼がいつも見ていた水の中を
    //   見つめながら息を引き取る際の
    //   最後の言葉はこうでした：
    //       「ああ、愛しい少年よ、むなしく！」
    //   その場所はすべての言葉を返しました。
    //   彼は叫びました：
    //            「さようなら。」
    //   そしてEchoが呼びかけました：
    //                   「さようなら！」
    //
    //     --オウィディウス、「変身物語」
    //       イアン・ジョンストン訳

    print("He has room in his heart for:", .{});

    // `field_names` は文字列のスライスで、structのフィールド名を保持しています
    // `field_types` は文字列のスライスで、structのフィールドの型を保持しています、
    //               `field_names` と同じ長さが保証されています
    const field_names = @typeInfo(Narcissus).@"struct".field_names;
    const field_types = @typeInfo(Narcissus).@"struct".field_types;

    // フィールドが 'void' 型の場合（まったくスペースを
    // 取らないゼロビット型！）はフィールド名を出力しないよう
    // これらの 'if' 文を完成させてください：
    if (field_types[0] != void) {
        print(" {s}", .{field_names[0]});
    }

    if (field_types[1] != void) {
        print(" {s}", .{field_names[1]});
    }

    if (field_types[2] != void) {
        print(" {s}", .{field_names[2]});
    }

    // 上のコードの繰り返しを見てください！嫌ですね、
    // 見ているだけでむずむずしてきます。
    //
    // 残念ながら、'fields'はコンパイル時にしか
    // 評価できないため、通常の'for'ループは使えません。
    // この"comptime"について学ぶ時期が来たようですね？
    // 心配しないでください、すぐにたどり着きます。

    print(".\n", .{});
}

// 注意：この演習はもともと以下の関数を含んでいませんでした。
// Zig 0.10.0以降、`@typeName`は返される型名の先頭に
// ソースファイル名を付けるようになりました。例えば、"Narcissus"が
// "065_builtins2.Narcissus"になりました。
//
// これを修正するため、型名の先頭からファイル名を
// 取り除く関数を追加しました。（"."の直後から始まる
// 型名のスライスを返します。）
//
// @typeName は演習070でも見ることになります。今は、
// 型を受け取りu8の「文字列」を返すことが分かれば十分です。
fn maximumNarcissism(myType: type) []const u8 {
    const find = @import("std").mem.find;

    // "065_builtins2.Narcissus" を "Narcissus" に変換する
    const name = @typeName(myType);
    return name[find(u8, name, ".").? + 1 ..];
}
