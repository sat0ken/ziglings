//
// 配列の受け渡しが面倒なことがあるのは見てきました。quiz3 の
// 特に恐ろしい関数定義を覚えているかもしれません。
// この関数はちょうど 4 つのアイテムを持つ配列しか受け取れません！
//
//     fn printPowersOfTwo(numbers: [4]u16) void { ... }
//
// これが配列の問題点です。サイズはデータ型の一部であり、
// その型のすべての使用箇所にハードコードする必要があります。
// この digits 配列は永遠に [10]u8 です：
//
//     var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
//
// ありがたいことに、Zig にはスライスがあります。スライスを使うと
// 開始アイテムと長さを動的に指定できます。digits 配列のスライスの例：
//
//     const foo = digits[0..1];  // 0
//     const bar = digits[3..9];  // 3 4 5 6 7 8
//     const baz = digits[5..9];  // 5 6 7 8
//     const all = digits[0..];   // 0 1 2 3 4 5 6 7 8 9
//
// ご覧の通り、スライス [x..y] は x のインデックスの最初のアイテムから始まり、
// 最後のアイテムは y-1 です。y を省略すると「残りすべてのアイテム」になります。
//
// u8 アイテムの配列に対するスライスの型は []u8 です。
//
const std = @import("std");

pub fn main() void {
    var cards = [8]u8{ 'A', '4', 'K', '8', '5', '2', 'Q', 'J' };

    // 最初の 4 枚のカードを hand1 に、残りを hand2 に入れてください。
    const hand1: []u8 = cards[0..4];
    const hand2: []u8 = cards[4..];

    std.debug.print("Hand1: ", .{});
    printHand(hand1);

    std.debug.print("Hand2: ", .{});
    printHand(hand2);
}

// この関数に手を貸してください。u8 スライスの手、です。
fn printHand(hand: []u8) void {
    for (hand) |h| {
        std.debug.print("{u} ", .{h});
    }
    std.debug.print("\n", .{});
}
//
// 豆知識：内部的に、スライスは最初のアイテムへのポインタと長さとして保存されます。
