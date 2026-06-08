//
// Io 値の取得方法がわかったので、非同期実行に使ってみましょう！
//
// io.async() は関数を起動して Future を返します。.await() を
// 呼び出すまで結果は必ずしも利用可能ではありません：
//
//     var future = io.async(someFunction, .{ arg1, arg2 });
//     const result = future.await(io);
//
// 関数はすぐに実行されるかもしれないし、別のスレッドで実行されるかも
// しれません - コードはそれを気にする必要はありません！それが
// Io 抽象化の美しさです。
//
// 重要：すべての Future は .await() か .cancel() のいずれかを
// 呼び出す必要があります。そうしないとリソースがリークします！
// 安全なパターンは：
//
//     var future = io.async(myFn, .{});
//     defer _ = future.cancel(io);  // 安全網
//     // ... 後で結果が欲しい場合：
//     const result = future.await(io);
//     // （cancel の後に await しても問題ありません - 結果を返すだけです）
//
// .await() と .cancel() はどちらもタスクが終わるまでブロックして
// 結果を返します。違いは .cancel() がタスクに次のキャンセルポイントで
// 停止するよう要求することです。
// どちらかを複数回呼び出しても安全です - 後続の呼び出しは
// 結果のコピーを返すだけです。
//
// computeAnswer が非同期で実行され、その結果が適切に
// await されるようにこのプログラムを修正してください。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // computeAnswer を非同期で起動します。
    var future = io.async(computeAnswer, .{ 6, 7 });
    defer _ = future.cancel(io); // 常にクリーンアップする！

    print("Computing... ", .{});

    // 結果を収集します。Future のどのメソッドが
    // 準備できるまでブロックして値を返しますか？
    const answer = future.???(io);

    print("The answer is: {}\n", .{answer});
}

fn computeAnswer(a: u32, b: u32) u32 {
    return a * b;
}
