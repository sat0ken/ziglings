//
// もう一つのよくある問題は、エラーによって複数の場所で終了する可能性がある
// コードブロックで、終了する前に何かを行う必要がある場合です
//（通常は後処理のクリーンアップ）。
//
// "errdefer"は、ブロックがエラーで終了した場合にのみ実行されるdeferです：
//
//     {
//         errdefer cleanup();
//         try canFail();
//     }
//
// cleanup()関数は、"try"文がcanFail()によって生成されたエラーを
// 返した場合にのみ呼び出されます。
//
const std = @import("std");

var counter: u32 = 0;

const MyErr = error{ GetFail, IncFail };

pub fn main() void {
    // 数値の取得に失敗した場合、プログラム全体を終了します：
    const a: u32 = makeNumber() catch return;
    const b: u32 = makeNumber() catch return;

    std.debug.print("Numbers: {}, {}\n", .{ a, b });
}

fn makeNumber() MyErr!u32 {
    std.debug.print("Getting number...", .{});

    // "failed"メッセージがmakeNumber()関数がエラーで終了した
    // 場合にのみ出力されるようにしてください：
    std.debug.print("failed!\n", .{});

    var num = try getNumber(); // <-- これは失敗するかもしれません！

    num = try increaseNumber(num); // <-- これも失敗するかもしれません！

    std.debug.print("got {}. ", .{num});

    return num;
}

fn getNumber() MyErr!u32 {
    // 失敗する_かもしれない_…でも失敗しません！
    return 4;
}

fn increaseNumber(n: u32) MyErr!u32 {
    // 2回目以降の呼び出しで失敗します！
    if (counter > 0) return MyErr.IncFail;

    // こっそりとした、奇妙なグローバル変数の操作。
    counter += 1;

    return n + 1;
}
