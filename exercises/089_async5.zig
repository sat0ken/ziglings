//
// 新しい Io システムの最も重要な機能の一つは構造化されたキャンセルです！
//
// すべての Future には .cancel() メソッドがあり、それは：
//   1. タスクに停止を要求します（次の「キャンセルポイント」で
//      error.Canceled を通じて）
//   2. タスクが実際に終わるまでブロックします
//   3. タスクが生成した結果を返します
//
// 「キャンセルポイント」とは error.Canceled を返せる任意の Io 関数です -
// 最も一般的なのは io.sleep() です：
//
//     fn myTask(io: std.Io) u32 {
//         io.sleep(...) catch |err| switch (err) {
//             error.Canceled => return 0,  // エラー処理
//         };
//         return 42;
//     }
//
// これはスレッドを強制終了するのとは根本的に異なります -
// タスクはクリーンアップして値を返す機会を得ます！
//
// 覚えておいてください：.await() と .cancel() はどちらもブロックして
// 結果を返します。唯一の違いは .cancel() がキャンセル要求も
// 送信することです。どちらも冪等です — どちらかを再度呼び出すと
// 同じ結果が返されるだけです。
//
// このプログラムを修正してください：遅いタスクは10秒かかりますが、
// 1秒後にキャンセルします。タスクはキャンセルを検出して
// 早期リターンするべきです。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var future = io.async(slowTask, .{io});
    defer _ = future.cancel(io); // 安全網

    // 1秒待ってから、10秒全部待つ代わりにキャンセルします。
    io.sleep(std.Io.Duration.fromSeconds(1), .awake) catch {};

    print("Canceling slow task...\n", .{});

    // 10秒待ちたくありません！
    // キャンセルを要求して結果を返す Future のメソッドはどれですか？
    const result = future.???(io);

    print("Task returned: {}\n", .{result});
}

fn slowTask(io: std.Io) u32 {
    print("Starting long computation...\n", .{});

    // 10秒間スリープしようとします - でもキャンセルされるかもしれません！
    io.sleep(std.Io.Duration.fromSeconds(10), .awake) catch |err| switch (err) {
        error.Canceled => {
            print("Task was canceled, cleaning up.\n", .{});
            return 0;
        },
    };

    print("Task completed normally.\n", .{});
    return 42;
}
