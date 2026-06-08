//
// async の真の力は複数のタスクを起動するときに発揮されます！
//
// io.async() を使うと、複数の操作を開始してから全部を await
// できます。Io バックエンドはそれらを並行して実行するかもしれません：
//
//     var f1 = io.async(taskA, .{});
//     defer _ = f1.cancel(io);
//     var f2 = io.async(taskB, .{});
//     defer _ = f2.cancel(io);
//     const a = f1.await(io);
//     const b = f2.await(io);
//
// defer パターンに注目：各 async 呼び出しの直後に defer cancel が
// あります。これにより、await に到達する前に早期リターンや
// エラーが発生した場合でもクリーンアップが保証されます。
// await/cancel は冪等なので、すでに await 済みの場合 defer は無害です。
//
// 両方のタスクを起動して結果を収集するようにこのプログラムを修正してください。
//
const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 両方のタスクを非同期で起動します。
    var future_a = io.async(slowAdd, .{ 1, 2 });
    defer _ = future_a.cancel(io);
    var future_b = ???(slowMul, .{ 6, 7 });
    defer _ = future_b.cancel(io);

    // 両方の結果を await します。
    const sum = future_a.await(io);
    const product = future_b.await(io);

    print("{} + {} = {}\n", .{ 1, 2, sum });
    print("{} * {} = {}\n", .{ 6, 7, product });
    print("Total: {}\n", .{sum + product});
}

fn slowAdd(a: u32, b: u32) u32 {
    return a + b;
}

fn slowMul(a: u32, b: u32) u32 {
    return a * b;
}
