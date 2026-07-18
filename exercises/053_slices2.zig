//
// 文字列にスライスを使いたいと思うかもしれません。結局のところ
// u8 文字の配列ですよね？文字列へのスライスはうまく動作します。
// ただ一つ注意点があります：Zig の文字列リテラルは不変（const）値なので、
// スライスの型を次から：
//
//     var foo: []u8 = "foobar"[0..3];
//
// 次に変更する必要があります：
//
//     var foo: []const u8 = "foobar"[0..3];
//
// この Zero Wing に着想を得たフレーズデスクランブラを修正してみてください：
const std = @import("std");

pub fn main() void {
    const scrambled = "great base for all your justice are belong to us";

    const base1: []const u8 = scrambled[15..23];
    const base2: []const u8 = scrambled[6..10];
    const base3: []const u8 = scrambled[32..];
    printPhrase(base1, base2, base3);

    const justice1: []const u8 = scrambled[11..14];
    const justice2: []const u8 = scrambled[0..5];
    const justice3: []const u8 = scrambled[24..31];
    printPhrase(justice1, justice2, justice3);

    std.debug.print("\n", .{});
}

fn printPhrase(part1: []const u8, part2: []const u8, part3: []const u8) void {
    std.debug.print("'{s} {s} {s}.' ", .{ part1, part2, part3 });
}
