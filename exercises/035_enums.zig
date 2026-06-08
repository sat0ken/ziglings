//
// "unreachable"文を使って作った小さな数学的仮想マシンを覚えていますか？
// オペコードの使い方には2つの問題がありました：
//
//   1. オペコードを番号で覚えなければならないのは良くありません。
//   2. Zigは有効なオペコードがいくつあるかわからないため、
//      "unreachable"を使わなければなりませんでした。
//
// "enum"はZigの構造で、数値に名前をつけてセットに格納できます。
// エラーセットによく似ています：
//
//     const Fruit = enum{ apple, pear, orange };
//
//     const my_fruit = Fruit.apple;
//
// 前のバージョンで使っていた数値の代わりにenumを使いましょう！
//
const std = @import("std");

// enumを完成させてください！
const Ops = enum { ??? };

pub fn main() void {
    const operations = [_]Ops{
        Ops.inc,
        Ops.inc,
        Ops.inc,
        Ops.pow,
        Ops.dec,
        Ops.dec,
    };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            Ops.inc => {
                current_value += 1;
            },
            Ops.dec => {
                current_value -= 1;
            },
            Ops.pow => {
                current_value *= current_value;
            },
            // "else"は必要ありません！なぜでしょうか？
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
