//
// Zigには、この一般的なエラー処理パターンの便利な省略形"try"があります：
//
//     canFail() catch |err| return err;
//
// これはより簡潔に次のように書けます：
//
//     try canFail();
//
const std = @import("std");

const MyNumberError = error{
    TooSmall,
    TooBig,
};

pub fn main() void {
    const a: u32 = addFive(44) catch 0;
    const b: u32 = addFive(14) catch 0;
    const c: u32 = addFive(4) catch 0;

    std.debug.print("a={}, b={}, c={}\n", .{ a, b, c });
}

fn addFive(n: u32) MyNumberError!u32 {
    // この関数はdetect()から返されるかもしれないエラーを返す必要があります。
    // "catch"ではなく"try"文を使ってください。
    //
    const x = try detect(n);

    return x + 5;
}

fn detect(n: u32) MyNumberError!u32 {
    if (n < 10) return MyNumberError.TooSmall;
    if (n > 20) return MyNumberError.TooBig;
    return n;
}
