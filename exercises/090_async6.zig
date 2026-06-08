//
// 複数のタスクをレースさせて、最初に終わったものに対して
// 処理したい場合があります。それが Select の用途です！
//
// Select は Group に似ていますが、タスクが完了するたびに
// 個別の結果を一度に一つ受け取れます：
//
//     const Race = std.Io.Select(union(enum) {
//         fast: u32,
//         slow: u32,
//     });
//
//     var buffer: [2]Race.Union = undefined;
//     var sel = Race.init(io, &buffer);
//
//     sel.async(.fast, fastFn, .{io});
//     sel.async(.slow, slowFn, .{io});
//
//     const winner = try sel.await();  // 最初に完了したものを返す
//     switch (winner) {
//         .fast => |val| ...,
//         .slow => |val| ...,
//     }
//     sel.cancelDiscard();  // 残りをキャンセルして結果を破棄
//
// 他のすべての async プリミティブと同様：Select 内でスポーンされた
// タスクは必ずクリーンアップしなければなりません。残りの結果を
// 一つずつ取得するには sel.cancel() を使い（リソースクリーンアップ用）、
// 不要な場合は sel.cancelDiscard() を使います。
//
// バッファは cancelDiscard() を呼び出すまでに完了するかもしれない
// すべてのタスクに対して十分な大きさでなければなりません。
//
// レースの勝者を受け取るようにこのプログラムを修正してください。
//
const std = @import("std");
const print = std.debug.print;

const RaceResult = std.Io.Select(union(enum) {
    hare: []const u8,
    tortoise: []const u8,
});

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buffer: [2]RaceResult.Union = undefined;
    var sel = RaceResult.init(io, &buffer);

    sel.async(.hare, runHare, .{io});
    sel.async(.tortoise, runTortoise, .{io});

    // 最初に終わったものを待ちます。
    // 最初に完了した結果を返す Select のメソッドは何ですか？
    const winner = try sel.???();

    switch (winner) {
        .hare => |msg| print("Hare: {s}\n", .{msg}),
        .tortoise => |msg| print("Tortoise: {s}\n", .{msg}),
    }

    // 負けた方をクリーンアップします - 結果は不要です。
    sel.cancelDiscard();
}

fn runHare(io: std.Io) []const u8 {
    // ウサギは速い - 1秒だけ！
    io.sleep(std.Io.Duration.fromSeconds(1), .awake) catch return "I got canceled!";
    return "I'm fast!";
}

fn runTortoise(io: std.Io) []const u8 {
    // カメは遅い - 10秒。
    io.sleep(std.Io.Duration.fromSeconds(10), .awake) catch return "I got canceled!";
    return "Slow and steady...";
}
