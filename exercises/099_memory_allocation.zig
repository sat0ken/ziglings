//
// これまでのほとんどの例では、入力はコンパイル時に分かっているため、
// プログラムが使用するメモリ量は固定されています。
// しかし、コンパイル時にサイズが分からない入力に対応する場合、
// 例えば：
//  - コマンドライン引数によるユーザー入力
//  - 別のプログラムからの入力
//
// プログラムが使用するメモリを実行時にオペレーティングシステムに
// 割り当てさせる必要があります。
//
// Zig はいくつかの異なるアロケーターを提供します。Zig の
// ドキュメントでは、一度割り当てて終了するシンプルなプログラムには
// Arena アロケーターを推奨しています：
//
//     const std = @import("std");
//
//     // メモリ割り当ては失敗する可能性があるため、戻り型は !void
//     pub fn main() !void {
//
//         var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//         defer arena.deinit();
//
//         const allocator = arena.allocator();
//
//         const ptr = try allocator.create(i32);
//         std.debug.print("ptr={*}\n", .{ptr});
//
//         const slice_ptr = try allocator.alloc(f64, 5);
//         std.debug.print("slice_ptr={*}\n", .{slice_ptr});
//     }

// 単純な整数や固定サイズのスライスの代わりに、
// このプログラムは入力配列と同じサイズのスライスを割り当てる必要があります。

// 一連の数値が与えられたとき、累積平均を求めます。つまり、
// 各項目 N には最後の N 要素の平均が含まれるべきです。

const std = @import("std");

fn runningAverage(arr: []const f64, avg: []f64) void {
    var sum: f64 = 0;

    for (0.., arr) |index, val| {
        sum += val;
        const f_index: f64 = @floatFromInt(index + 1);
        avg[index] = sum / f_index;
    }
}

pub fn main() !void {
    // ユーザー入力を読み込んで定義されたと仮定します
    const arr: []const f64 = &[_]f64{ 0.3, 0.2, 0.1, 0.1, 0.4 };

    // アロケーターを初期化します
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    // 終了時にメモリを解放します
    defer arena.deinit();

    // アロケーターを初期化します
    const allocator = arena.allocator();

    // この配列のメモリを割り当てます
    const avg: []f64 = ???;

    runningAverage(arr, avg);
    std.debug.print("Running Average: ", .{});
    for (avg) |val| {
        std.debug.print("{d:.2} ", .{val});
    }
    std.debug.print("\n", .{});
}

// メモリ割り当てと異なる種類のメモリアロケーターの詳細については、
// https://www.youtube.com/watch?v=vHWiDx_l4V0 を参照してください
