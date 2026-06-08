//
// 個別の値を返さない多数のタスクがある場合は、Group を使いましょう！
// Group はタスクの順序なし集合で、全体としてのみ await または
// cancel できます：
//
//     var group: std.Io.Group = .init;
//     group.async(io, myTask, .{arg1});
//     group.async(io, myTask, .{arg2});
//     try group.await(io);  // すべてのタスクが終わるまでブロック
//
// 重要なルール：
//   * グループ内でスポーンされた関数の戻り型は
//     Cancelable!void（つまり void または error{Canceled}!void）に
//     強制変換可能でなければなりません。
//   * group.async() を呼び出したら、必ず最終的に
//     group.await() か group.cancel() を呼び出してリソースを解放してください。
//   * group.cancel() はすべてのメンバーにキャンセルを要求し、
//     全員が終わるまでブロックします。
//
// Future と違い、Group のタスクは呼び出し元に値を返しません。
// 共有状態やサイドエフェクト（出力など）を通じて通信する
// 並列処理に最適です。
//
// グループ内のすべてのタスクを await するようにこのプログラムを修正してください。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var group: std.Io.Group = .init;

    // 任意の順序で3つのタスクをスポーンします。各タスクは (id * 1) 秒
    // スリープしてから出力するので、出力順序は決定論的です。
    group.async(io, doWork, .{ io, 1 });
    group.async(io, doWork, .{ io, 3 });
    group.async(io, doWork, .{ io, 2 });

    // すべてのタスクが終わるまで待ちます。
    // すべてのタスクの完了までブロックする Group のメソッドは何ですか？
    try group.???(io);

    print("All tasks finished!\n", .{});
}

fn doWork(io: std.Io, id: u32) void {
    // 決定論的な出力順序を保証するためにスリープします。
    io.sleep(std.Io.Duration.fromSeconds(id), .awake) catch return;
    print("Task {} done.\n", .{id});
}
