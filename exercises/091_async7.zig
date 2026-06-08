//
// 複数の非同期タスクが共有データにアクセスする場合、
// 同期が必要です！Io はこのための Mutex を提供します：
//
//     var mutex: std.Io.Mutex = .init;
//
//     // タスク内で：
//     try mutex.lock(io);       // ロックが取得されるまでブロック
//     defer mutex.unlock(io);
//     // ... クリティカルセクション：共有データの変更が安全 ...
//
// mutex なしでは、並行タスクが同じメモリを同時に読み書きして
// データ競合が発生し、結果が予測不能になる可能性があります。
//
// mutex.lock() はキャンセルポイントです — error.Canceled を
// 返すことがあります。すぐに返す tryLock() もあります
// （取得できた場合は true、できなかった場合は false）。
//
// カウンターが正しく同期されるようにこのプログラムを修正してください。
// 修正なしでは最終カウントが予測不能になります。
// 修正後は、4つのタスクが各100回インクリメント = 400 になります。
//
const std = @import("std");
const print = std.debug.print;

const SharedState = struct {
    counter: u32 = 0,
    mutex: std.Io.Mutex = .init,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var state = SharedState{};

    var group: std.Io.Group = .init;

    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });
    group.async(io, increment, .{ io, &state, 100 });

    try group.await(io);

    print("Counter: {}\n", .{state.counter});
}

fn increment(io: std.Io, state: *SharedState, times: u32) void {
    for (0..times) |_| {
        // 共有状態を変更する前にロックを取得します。
        // ロックが取得されるまでブロックする Mutex のメソッドは何ですか？
        state.mutex.??? catch return;
        defer state.mutex.unlock(); // <-- ここに何が足りませんか？

        // その間に他のタスクが実行できるようにスリープします。
        // これは非決定性をより見えやすくするためだけに行います。
        io.sleep(std.Io.Duration.fromMilliseconds(1), .awake) catch {};

        // mutex のロックを怠ると何が起きますか？

        state.counter += 1;
    }
}
