//
// Zigには配列演算子が1つあります。
//
// '++' を使って2つの配列を連結できます：
//
//   const a = [_]u8{ 1,2 };
//   const b = [_]u8{ 3,4 };
//   const c = a ++ b ++ [_]u8{ 5 }; // 1 2 3 4 5 になります
//
// '++' はプログラムが _コンパイルされている_ 間だけ配列に対して動作します。
// この特別な時間はZigの用語で「comptime（コンパイル時）」と呼ばれ、
// 後でさらに詳しく学びます。
//
const std = @import("std");

pub fn main() void {
    const le = [_]u8{ 1, 3 };
    const et = [_]u8{ 3, 7 };

    // （問題1）
    // 上の2つの配列を連結してこの配列を設定してください。
    // 結果は: 1 3 3 7 となるはずです
    const leet = le ++ et;

    // （問題2）
    // 繰り返しを使ってこの配列を設定してください。
    // 結果は: 1 0 0 1 1 0 0 1 1 0 0 1 となるはずです
    const bit_pattern_unit = [_]u8{ 1, 0, 0, 1 };
    const bit_pattern: [3 * bit_pattern_unit.len]u8 = @bitCast(@as([3][bit_pattern_unit.len]u8, @splat(bit_pattern_unit)));

    // 問題はここまでです。結果を確認しましょう。
    //
    // これらの配列を leet[0], leet[1],... で出力することもできますが、
    // 代わりに Zig の 'for' ループを少しプレビューしましょう：
    //
    //    for (<item array>) |item| { <do something with item> }
    //
    // 心配しなくても、後続のレッスンでループをきちんと説明します。
    //
    std.debug.print("LEET: ", .{});

    for (leet) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print(", Bits: ", .{});

    for (bit_pattern) |n| {
        std.debug.print("{}", .{n});
    }

    std.debug.print("\n", .{});
}
