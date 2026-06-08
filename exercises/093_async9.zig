//
// io.async() を使ってタスクを起動してきましたが、より強力な
// バリアントがあります：io.concurrent() です。
//
// 違い：
//
//   io.async():
//     * 関数は別の並行処理ユニットで実行されるかもしれないし、
//       呼び出し元で即座に（同期的に）実行されるかもしれません。
//     * 絶対に失敗しません — 並行処理が利用できない場合、
//       関数をすぐに実行するだけです。
//     * より移植性が高く、すべての Io バックエンドで動作します。
//
//   io.concurrent():
//     * 別の並行処理ユニットを保証します。
//     * リソースが枯渇したりバックエンドがサポートしない場合、
//       error.ConcurrencyUnavailable で失敗することがあります。
//     * タスクが呼び出し元とは独立して実行される必要がある場合に使用します。
//
// 「並行処理ユニット」とは何ですか？それはバックエンドによります！
// Threaded バックエンドは OS スレッドを使います。しかし Evented バックエンド
// （Uring、Kqueue、Dispatch）は M:N グリーンスレッド/ファイバーを使い、
// 単一の OS スレッドでも並行処理を提供できます。
// コードはその違いを知る必要はありません。
//
// concurrent() は失敗する可能性があるため、エラーを処理する必要があります：
//
//     var future = try io.concurrent(myFn, .{args});
//     defer _ = future.cancel(io);
//     const result = future.await(io);
//
// 信号処理からの少し単純化した例を試してみましょう：
// ノイズレベルを超える信号の開始点を探しているとします。
// そのために、先頭から末尾に向かって各エントリをしきい値と比較します。
// 処理を速くするために、信号を2つの半分に分割して
// 2つの並行ワーカーにそれぞれ探させます。
// 最初に見つけた方が「勝ち」となり、もう一方を終了させます。
//
// これは単純化した説明ですが、実際にはほぼこのように行われます。
//
const std = @import("std");
const Io = std.Io;
const print = std.debug.print;

const SearchResult = struct {
    found: bool,
    worker_id: u8 = 0,
    index: usize = 0,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const data = [_]u32{ 10, 23, 45, 67, 12, 69, 3, 54, 69, 42, 68, 56, 71, 79, 79, 75, 70, 77 };
    const threshold = 70;
    const mid = data.len / 2;

    // 1つの結果を格納するキュー。
    var buf: [1]SearchResult = undefined;
    var queue = Io.Queue(SearchResult).init(&buf);

    // 2つのワーカーを起動し、それぞれが配列の半分を検索します。
    // 別々の並行処理ユニットを保証したいことを忘れずに。
    var f1 = ???(searchThreshold, .{ io, data[0..mid], threshold, 0, 0, &queue });
    defer _ = f1.cancel(io);

    var f2 = ???(searchThreshold, .{ io, data[mid..], threshold, mid, 1, &queue });
    defer _ = f2.cancel(io);

    // 最初の結果を待ちます。
    const result = try queue.getOne(io);

    if (result.found)
        print("Worker {} found signal start over threshold at index {}!\n", .{ result.worker_id, result.index });
}

fn searchThreshold(
    io: Io,
    slice: []const u32,
    threshold: u32,
    base_offset: usize,
    worker_id: u8,
    queue: *Io.Queue(SearchResult),
) void {
    for (slice, 0..) |val, i| {
        // 別のワーカーがすでに終了した場合にプロセスをキャンセルできるように
        // この一時停止が必要です。この一時停止がなければ、
        // すべてのワーカーが最後まで続けてしまいます。
        io.sleep(Io.Duration.fromMilliseconds(1), .awake) catch return;

        // テストのために、ワーカーの動作を確認するには以下をコメント解除し、
        // 一時停止をコメントアウトします。
        // print("id: {} - val: {}\n", .{ worker_id, val });

        if (val >= threshold) {
            queue.putOne(io, .{
                .found = true,
                .worker_id = worker_id,
                .index = base_offset + i,
            }) catch return;
            return;
        }
    }

    // 見つからなかった場合
    queue.putOneUncancelable(io, .{ .found = false }) catch return;
}
