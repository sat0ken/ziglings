//
// "defer"文を使うことで、コードブロックが終了した_後_に
// 実行されるコードを割り当てることができます：
//
//     {
//         defer runLater();
//         runNow();
//     }
//
// 上の例では、runLater()はブロック({...})が終了したときに実行されます。
// そのため、上のコードは次の順序で実行されます：
//
//     runNow();
//     runLater();
//
// この機能は最初は不思議に思えるかもしれませんが、次の演習で
// どのように役立つかを見ていきます。
const std = @import("std");

pub fn main() void {
    // 他は何も変えずに、このコードに'defer'文を追加して
    // "One Two\n"と出力されるようにしてください：
    defer std.debug.print("Two\n", .{});
    std.debug.print("One ", .{});
}
