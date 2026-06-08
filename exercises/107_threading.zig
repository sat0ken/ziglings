//
// エクササイズ84〜91では、並行実行のためのZigのIoインターフェースを学びました：
// io.async()、Group、Select、Futuresです。
// 内部では、ThreadedバックエンドがOSスレッドのプールを管理します。
// スケジューリング、キャンセル、リソースのクリーンアップを含めて。
//
// しかし、スレッドを直接制御する必要がある場合もあります：
//   * 長期間動作する専用ワーカー
//   * 特定のスタックサイズやスレッド数
//   * Ioインターフェースが利用できないコード
//   * 細かい同期パターン
//
// そこでstd.Threadの出番です。自分でspawn、管理、joinする
// 生のOSスレッドを提供します。プールもFuturesも自動キャンセルもありませんが、
// 完全な制御が得られます。
//
// 以下の図は、さまざまな種類のプロセス実行の違いを大まかに示しています：
//
//
// 同期処理       非同期処理        マルチスレッド
// ┌──────────┐ ┌──────────┐  ┌──────────┐ ┌──────────┐
// │ Thread 1 │ │ Thread 1 │  │ Thread 1 │ │ Thread 2 │
// ├──────────┤ ├──────────┤  ├──────────┤ ├──────────┤    全体の時間
// └──┼┼┼┼┼───┴─┴──┼┼┼┼┼───┴──┴──┼┼┼┼┼───┴─┴──┼┼┼┼┼───┴──┬───────┬───────┬──
//    ├───┤        ├───┤         ├───┤        ├───┤      │       │       │
//    │ T │        │ T │         │ T │        │ T │      │       │       │
//    │ a │        │ a │         │ a │        │ a │      │       │       │
//    │ s │        │ s │         │ s │        │ s │      │       │       │
//    │ k │        │ k │         │ k │        │ k │      │       │       │
//    │   │        │   │         │   │        │   │      │       │       │
//    │ 1 │        │ 1 │         │ 1 │        │ 3 │      │       │       │
//    └─┬─┘        └─┬─┘         └─┬─┘        └─┬─┘      │       │       │
//      │            │             │            │      5秒      │       │
// ┌────┴───┐      ┌─┴─┐         ┌─┴─┐        ┌─┴─┐      │       │       │
// │ブロック │      │ T │         │ T │        │ T │      │       │       │
// └────┬───┘      │ a │         │ a │        │ a │      │       │       │
//      │          │ s │         │ s │        │ s │      │     8秒       │
//    ┌─┴─┐        │ k │         │ k │        │ k │      │       │       │
//    │ T │        │   │         │   │        │   │      │       │       │
//    │ a │        │ 2 │         │ 2 │        │ 4 │      │       │       │
//    │ s │        └─┬─┘         ├───┤        ├───┤      │       │       │
//    │ k │          │           │┼┼┼│        │┼┼┼│      ▼       │    10秒
//    │   │        ┌─┴─┐         └───┴────────┴───┴─────────     │       │
//    │ 1 │        │ T │                                         │       │
//    └─┬─┘        │ a │                                         │       │
//      │          │ s │                                         │       │
//    ┌─┴─┐        │ k │                                         │       │
//    │ T │        │   │                                         │       │
//    │ a │        │ 1 │                                         │       │
//    │ s │        ├───┤                                         │       │
//    │ k │        │┼┼┼│                                         ▼       │
//    │   │        └───┴────────────────────────────────────────────     │
//    │ 2 │                                                              │
//    ├───┤                                                              │
//    │┼┼┼│                                                              ▼
//    └───┴────────────────────────────────────────────────────────────────
//
//
// この図は、非同期処理とマルチスレッドの違いを詳しく説明した
// ブログの図を参考にモデル化されました：
// https://blog.devgenius.io/multi-threading-vs-asynchronous-programming-what-is-the-difference-3ebfe1179a5
//
// このエクササイズは本質的にZigでのアプローチを明確にすることについてであり、
// そのためできるだけシンプルに保つようにしています。
// マルチスレッド自体はすでに十分難しいですから。 ;-)
//
const std = @import("std");

pub fn main() !void {
    // ここで並列処理が始まる前の準備作業が行われます。
    std.debug.print("Starting work...\n", .{});

    // これらの波括弧は非常に重要で、スレッドが呼び出される
    // エリアを囲むために必要です。
    // これらの括弧がなければ、プログラムはスレッドの終了を
    // 待たず、プログラムの終了を超えて実行が続きます。
    {
        // 最初のスレッドをパラメータとして番号を渡して開始します
        const handle = try std.Thread.spawn(.{}, thread_function, .{1});

        // スレッドが完了するのを待ち、
        // `spawn()`で作成されたリソースを解放します。
        defer handle.join();

        // 2番目のスレッド
        const handle2 = try std.Thread.spawn(.{}, thread_function, .{-4}); // これは正しくないのでは？
        defer handle2.join();

        // 3番目のスレッド
        const handle3 = try std.Thread.spawn(.{}, thread_function, .{3});
        defer ??? // <-- 何かが足りません

        // スレッドが開始された後、
        // それらは並列で実行され、その間にも作業を続けられます。
        var io_instance: std.Io.Threaded = .init_single_threaded;
        const io = io_instance.io();
        try io.sleep(std.Io.Duration.fromMilliseconds(400), .awake);
        std.debug.print("Some weird stuff, after starting the threads.\n", .{});
    }
    // 閉じたエリアを出た後、まだ実行中であれば
    // スレッドが完了するまで待ちます。
    std.debug.print("Zig is cool!\n", .{});
}

// この関数は設定したすべてのスレッドで起動されます。
// この例では、スレッドの番号をパラメータとして渡します。
fn thread_function(id: usize) !void {
    var io_instance: std.Io.Threaded = .init_single_threaded;
    const io = io_instance.io();
    try io.sleep(std.Io.Duration.fromMilliseconds(100 * @as(isize, @intCast(id))), .awake);
    std.debug.print("thread {d}: {s}\n", .{ id, "started." });

    // このタイマーはスレッドの作業をシミュレートします。
    const work_time = 300 * ((5 - id % 3) - 2);
    try io.sleep(std.Io.Duration.fromMilliseconds(@intCast(work_time)), .awake);

    std.debug.print("thread {d}: {s}\n", .{ id, "finished." });
}
// これはスレッドを並列で実行する最も簡単な方法です。
// しかし一般的には、より多くの管理作業が必要です。
// 例えば、プールを設定してセマフォを使ってスレッド同士が
// 通信できるようにするなどです。
//
// しかし、それは別のエクササイズのテーマです。
