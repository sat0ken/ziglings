//
// 最初のエラー演習を振り返ってみましょう。今回は
// "if"文のエラー処理バリアントを見ていきます。
//
//     if (foo) |value| {
//
//         // fooはエラーではなかった；valueはfooのエラーでない値
//
//     } else |err| {
//
//         // fooはエラーだった；errはfooのエラー値
//
//     }
//
// さらに進んで、switch文を使ってエラーの種類を処理します。
//
//     if (foo) |value| {
//         ...
//     } else |err| switch (err) {
//         ...
//     }
//
const MyNumberError = error{
    TooBig,
    TooSmall,
};

const std = @import("std");

pub fn main() void {
    const nums = [_]u8{ 2, 3, 4, 5, 6 };

    for (nums) |num| {
        std.debug.print("{}", .{num});

        const n = numberMaybeFail(num);
        if (n) |value| {
            std.debug.print("={}. ", .{value});
        } else |err| switch (err) {
            MyNumberError.TooBig => std.debug.print(">4. ", .{}),
            // TooSmallのマッチをここに追加して"<4. "と出力されるようにしてください
        }
    }

    std.debug.print("\n", .{});
}

// 今回はnumberMaybeFail()がエラーそのものではなく
// エラーユニオンを返すようにします。
fn numberMaybeFail(n: u8) MyNumberError!u8 {
    if (n > 4) return MyNumberError.TooBig;
    if (n < 4) return MyNumberError.TooSmall;
    return n;
}
