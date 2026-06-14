//
// Zigには"unreachable"文があります。コードのブランチが決して
// 実行されないことをコンパイラに伝えたいとき、そこに到達すること自体が
// エラーであるときに使います。
//
//     if (true) {
//         ...
//     } else {
//         unreachable;
//     }
//
// ここでは数値に対して数学的な操作を実行する小さな仮想マシンを作りました。
// 見た目は良いのですが、一つ問題があります：switch文が
// u8の全ての取りうる値をカバーしていません！
//
// 有効なオペコードは3つしかないことはわかっていますが、Zigにはわかりません。
// unreachable文を使ってswitchを完全にしてください。さもなければ。 :-)
//
const std = @import("std");

pub fn main() void {
    const operations = [_]u8{ 1, 1, 1, 3, 2, 2 };

    var current_value: u32 = 0;

    for (operations) |op| {
        switch (op) {
            1 => {
                current_value += 1;
            },
            2 => {
                current_value -= 1;
            },
            3 => {
                current_value *= current_value;
            },
            else => {
                unreachable;
            }
        }

        std.debug.print("{} ", .{current_value});
    }

    std.debug.print("\n", .{});
}
