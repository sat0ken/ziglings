//
// いよいよ楽しいところに入ります。'if' 文から始めましょう！
//
//     if (true) {
//         ...
//     } else {
//         ...
//     }
//
// Zigには次のような「通常の」比較演算子があります：
//
//     a == b   は「a は b と等しい」を意味します
//     a < b    は「a は b より小さい」を意味します
//     a > b    は「a は b より大きい」を意味します
//     a != b   は「a は b と等しくない」を意味します
//
// Zigの "if" で重要なのは、ブール値*のみ*を受け付けることです。
// 数値や他のデータ型を true や false に強制変換しません。
//
const std = @import("std");

pub fn main() void {
    const foo = 42;

    // この条件を修正してください：
    if (foo == 42) {
        // このメッセージを表示したいです！
        std.debug.print("Foo is 42!\n", .{});
    } else {
        std.debug.print("Foo is not 42!\n", .{});
    }
}
