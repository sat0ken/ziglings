//
// エクササイズ097、098、クイズ110でビット演算を使ったビット操作について
// 十分に学びました。すでに知っているテクニックは問題なく動作しますが、
// マスクの作成や個々のビットのシフトはすぐに面倒で扱いにくくなります。
// 個々のビットを制御するより良い、より便利な方法があったら？
//
// 幸いにも、Zigにはまさにこの目的のためのキーワードがあります：
//
//     packed
//
// これ単体では何もしません。そのポテンシャルを引き出すために（そして
// プログラムをコンパイルできるようにするために）、structまたはunionの
// 宣言に付ける必要があります：
//
//     const Foo = packed struct { ... };
//     const Bar = packed union { ... };
//
// では、このキーワードは何をするのでしょうか？
// この質問に答えるには、まず*コンテナレイアウト*について説明する必要があります。
//
// 通常のstructとunionは`auto`レイアウトを使用します。サイズやフィールドの順序について
// 保証を与えません。どちらもコンパイラ次第です（ただし、サイズとフィールドの順序は
// 同一のコンパイル単位内では同じであることが保証されています）。
//
// コンテナに`packed`キーワードを付けると`packed`レイアウトが使用されます：
// 突然、すべてのフィールドがパディングなしで*ぎっしりと*まとめられ、
// その順序はソースコードに指定されたものと同じであることが保証されます。
// structの場合、コンテナのサイズはすべてのフィールドの（ビット）サイズの合計であることが
// 保証されます。unionの場合、すべてのフィールドは全く同じ（ビット）サイズである
// 必要があります（パディングなし）。union自体もこのサイズであることが保証されます。
//
// Cに慣れ親しんでいる場合、別の文脈でstructパッキングについて
// 聞いたことがあるかもしれません：フィールドをアライメントパディングが
// 最小になるように配置すること（またはコンパイラにそれをやってもらうこと）。
// これはZigの`packed`キーワードの目的ではありません！
//
// 以下のcomptime assertionをパスさせてみましょう：

const PackedStruct = packed struct {
    a: u2,
    b: u?,
};

comptime {
    assert(@bitSizeOf(PackedStruct) == 6);
}

const PackedUnion = packed union {
    a: bool,
    b: u?,
};

comptime {
    assert(@bitSizeOf(PackedUnion) == 1);
}

// では、この新しい知識をビット操作にどう活用できるでしょうか？
//
// おそらくすでに推測しているように、`packed`コンテナはビットフラグや
// ファイルヘッダーやネットワークプロトコルでよく見られる
// 他のタイトに詰められたビットサイズの値の集合を表現するのに非常に便利です。
//
// 実際の例を見てみましょう：
// LZ4圧縮フォーマット（†）は圧縮データを記述するためのフレームフォーマットを指定しています。
// 各LZ4フレームにはディスクリプタがあり、各ディスクリプタにはそのフレームの内容を
// 指定する'FLG'バイトが含まれています：

/// |  BitNb  |  7-6  |   5   |    4     |  3   |    2     |   1    |   0  |
/// | ------- |-------|-------|----------|------|----------|--------|------|
/// |FieldName|Version|B.Indep|B.Checksum|C.Size|C.Checksum|Reserved|DictID|
///
const FLG = packed struct(u8) {
    dict_id: bool,
    reserved: u1 = 0,
    content_checksum: bool,
    content_size: bool,
    block_checksum: bool,
    block_indepencence: bool,
    version: u2,
};

// ちょっと待ってください、`struct`キーワードの後の`(u8)`は何でしょうか？
// 整数はこれと何の関係があるのでしょうか？
// これは何かを明らかにする良い機会です：
// packed structとpacked unionは実際にはstructやunionではありません...
// これらは単に整数が変装したものです！すべての目的において、
// それらのフィールドは単に基礎となるビットの範囲に便利な名前を付けたものです。
// packed コンテナのサイズ要件を強制しやすくするために、Zigではenumと同様に
// それらの*バッキング整数*を指定できます。
//
// `FLG`の場合、structが正確に1バイトを占有することを望むので、
// `u8`をバッキング整数として指定します。ビルトイン`@bitCast`を使って
// packedコンテナとそのバッキング整数の間で安全に変換できます。
// LZ4の仕様では予約ビットは常にゼロでなければならないと定められているので、
// `reserved`のデフォルト値として`0`を設定するのが良い慣行です。
//
// packed structのフィールドはバッキング整数の最下位ビットから始まり、
// 最上位ビットで終わります。これはターゲットのエンディアンに関わらず同じです。
//
// 以下の不満を解消してみましょう：

const Bits = packed struct(u4) {
    a: u1 = 0,
    b: u1 = 0,
    c: u1 = 0,
    d: u1 = 0,
};

pub fn main() void {
    {
        const expected: Bits = @bitCast(@as(u4, 0b1000));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0001));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0010));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b0011));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }

    {
        const expected: Bits = @bitCast(@as(u4, 0b1101));
        const my_bits: Bits = .{};
        if (my_bits != expected) complain(my_bits, expected, @src());
    }
}

// 見てわかるように、等値比較（`==`と`!=`）はpacked structで動作します。
// packed unionでも動作します。ただし、packed コンテナは自然には順序付けられないため、
// それらに対して他の比較演算子を使用することはできません。
//
// packed コンテナを`switch`文で使用することも可能で、
// これは次のエクササイズでカバーします！
//
// packed コンテナはメモリレイアウトについて非常に強い保証をするため、
// それらの一部として使用できる型は限られています。
// フィールド型として許可されている型：
//
// - 整数型
// - 浮動小数点型
// - bool
// - void
// - 明示的なバッキング整数を持つenum
// - packed union
// - packed struct
//

const std = @import("std");
const assert = std.debug.assert;

fn complain(my_bits: Bits, expected: Bits, src_loc: std.builtin.SourceLocation) void {
    std.debug.print(
        "That's not quite right! You've got 0b{b:0>4}, but we want 0b{b:0>4} in line {d}.\n",
        .{ @as(u4, @bitCast(my_bits)), @as(u4, @bitCast(expected)), src_loc.line },
    );
}

// (†) https://github.com/lz4/lz4/blob/5c4c1fb2354133e1f3b087a341576985f8114bd5/doc/lz4_Frame_format.md#frame-descriptor
