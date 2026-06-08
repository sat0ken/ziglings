//
// タスク間で通信が必要なことがよくあります！Io はそのために Queue を
// 提供します — タスク間でデータを渡すための有界スレッドセーフチャネルです：
//
//     var backing: [16]u32 = undefined;
//     var queue: std.Io.Queue(u32) = .init(&backing);
//
//     // プロデューサータスク：
//     try queue.putOne(io, value);    // キューが満杯の場合ブロック
//
//     // コンシューマータスク：
//     const val = try queue.getOne(io);  // キューが空の場合ブロック
//
// プロデューサーが終わったら queue.close(io) を呼び出して
// データがこれ以上来ないことを知らせます。その後、キューが
// ドレインされると getOne() は error.Closed を返します。
//
// これは古典的なプロデューサー/コンシューマーパターンです —
// 一つのタスクが仕事を生成し、別のタスクがそれを処理し、
// キューがすべての同期を自動的に処理します。
//
// このプログラムを修正してください：プロデューサーは1..10の数値を送り、
// コンシューマーはそれらを合計します。期待される合計は 55 です。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var backing: [4]u32 = undefined;
    var queue: std.Io.Queue(u32) = .init(&backing);

    var group: std.Io.Group = .init;

    group.async(io, producer, .{ io, &queue });
    group.async(io, consumer, .{ io, &queue });

    try group.await(io);
}

fn producer(io: std.Io, queue: *std.Io.Queue(u32)) void {
    // 1から10までの数値をキューに送ります。
    for (1..11) |i| {
        // 単一の要素を送り、満杯の場合ブロックする Queue のメソッドは何ですか？
        queue.???(io, @intCast(i)) catch return;
    }
    // 送信が完了したことを知らせます。
    queue.close(io);
}

fn consumer(io: std.Io, queue: *std.Io.Queue(u32)) void {
    var sum: u32 = 0;
    while (true) {
        const value = queue.getOne(io) catch |err| switch (err) {
            error.Closed => break,
            error.Canceled => return,
        };
        sum += value;
    }
    print("Sum of 1..10 = {}\n", .{sum});
}
