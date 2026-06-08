//
// 演習089で、キャンセルは「キャンセルポイント」— error.Canceled を
// 返せる任意の Io 関数 — で発生することを学びました。
//
// しかし時には、タスクに絶対に割り込まれてはいけないクリティカルセクションが
// あります — 例えば、一貫した状態をディスクに書き込んだり、
// トランザクションを完了させたりする場合です。
//
// Io はそのために CancelProtection を提供します：
//
//     const old = io.swapCancelProtection(.blocked);
//     defer _ = io.swapCancelProtection(old);

//     // このブロックでは、どの Io 関数も error.Canceled を返しません。
//     // キャンセル要求は保護が解除されるまで保留されます。
//
// 2つの状態があります：
//   .unblocked — 通常：キャンセルポイントが発火できます（デフォルト）
//   .blocked   — 保護中：error.Canceled は絶対に返されません
//
// io.checkCancel() もあります — キャンセル要求が保留中の場合に
// error.Canceled を返すだけの純粋なキャンセルポイントです。
// 長い CPU バウンドループで便利です。
//
// そして io.recancel() — 消費されたキャンセル要求を再武装して
// 次のキャンセルポイントが再び発火するようにします。
//
// タスクがキャンセルされてもクリティカルセクションが完了するように
// このプログラムを修正してください。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var future = io.async(importantTask, .{io});
    defer _ = future.cancel(io);

    // タスクがクリティカルセクションに入るまで時間を与えます。
    io.sleep(std.Io.Duration.fromMilliseconds(200), .awake) catch {};

    // タスクが保護されたセクションにいる間にキャンセルします。
    const result = future.cancel(io);
    print("Task result: {s}\n", .{result});
}

fn importantTask(io: std.Io) []const u8 {
    print("Starting critical section...\n", .{});

    // このセクションをキャンセルから保護します。
    // キャンセル保護状態を切り替えるメソッドは何ですか？
    const old = io.???(.blocked);
    defer _ = io.???(old);

    // このスリープは保護が有効な間はキャンセルされても
    // error.Canceled を返しません！
    io.sleep(std.Io.Duration.fromMilliseconds(300), .awake) catch |err| switch (err) {
        error.Canceled => {
            // 保護中はこれは絶対に起きてはいけません！
            return "ERROR: canceled during critical section!";
        },
    };

    print("Critical section completed safely.\n", .{});
    return "All data saved.";
}
