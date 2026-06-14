//
// "switch"文は式の取りうる値に一致させて、それぞれで
// 異なる処理を実行できます。
//
// このswitch：
//
//     switch (players) {
//         1 => startOnePlayerGame(),
//         2 => startTwoPlayerGame(),
//         else => {
//             alert();
//             return GameError.TooManyPlayers;
//         }
//     }
//
// は、このif/elseと等価です：
//
//     if (players == 1) startOnePlayerGame();
//     else if (players == 2) startTwoPlayerGame();
//     else {
//         alert();
//         return GameError.TooManyPlayers;
//     }
//
const std = @import("std");

pub fn main() void {
    const lang_chars = [_]u8{ 26, 9, 7, 42 };

    for (lang_chars) |c| {
        switch (c) {
            1 => std.debug.print("A", .{}),
            2 => std.debug.print("B", .{}),
            3 => std.debug.print("C", .{}),
            4 => std.debug.print("D", .{}),
            5 => std.debug.print("E", .{}),
            6 => std.debug.print("F", .{}),
            7 => std.debug.print("G", .{}),
            8 => std.debug.print("H", .{}),
            9 => std.debug.print("I", .{}),
            10 => std.debug.print("J", .{}),
            // ... 途中は省略 ...
            25 => std.debug.print("Y", .{}),
            26 => std.debug.print("Z", .{}),
            // switch文は「網羅的」でなければなりません（すべての
            // 取りうる値に一致するものが必要です）。cが
            // 既存のどのマッチにも一致しない場合に"?"を出力する
            // "else"をこのswitchに追加してください。
            else => {
                std.debug.print("?", .{});
            }
        }
    }

    std.debug.print("\n", .{});
}
