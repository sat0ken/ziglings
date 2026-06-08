//
// 面白い機能です：Zigには複数行文字列があります！
//
// 複数行文字列を作るには、コードコメントと同じように各行の先頭に
// '\\' を付けます（バックスラッシュを使います）：
//
//     const two_lines =
//         \\Line One
//         \\Line Two
//     ;
//
// このプログラムで歌詞を表示できるか試してみてください。
//
const std = @import("std");

pub fn main() void {
    const lyrics =
        Ziggy played guitar
        Jamming good with Andrew Kelley
        And the Spiders from Mars
    ;

    std.debug.print("{s}\n", .{lyrics});
}
