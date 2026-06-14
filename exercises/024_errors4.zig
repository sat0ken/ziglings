//
// `catch`でエラーをデフォルト値に置き換える方法は、エラーの種類に
// 関係なく適用されるため、やや雑なアプローチです。
//
// catchにはエラー値をキャプチャして追加の処理を行う形式があります：
//
//     canFail() catch |err| {
//         if (err == FishError.TunaMalfunction) {
//             ...
//         }
//     };
//
const std = @import("std");

const MyNumberError = error{
    TooSmall,
    TooBig,
};

pub fn main() void {
    // 以下の "catch 0" は、makeJustRight()が返すエラーユニオンを
    // 一時的に処理するための仮の対処です（今のところ）。
    const a: u32 = makeJustRight(44) catch 0;
    const b: u32 = makeJustRight(14) catch 0;
    const c: u32 = makeJustRight(4) catch 0;

    std.debug.print("a={}, b={}, c={}\n", .{ a, b, c });
}

// この少し変わった例では、数値を適切な値にする責任を
// 4つ(!)の関数に分けています：
//
//     makeJustRight()   fixTooBig()を呼び出し、エラーを修正できない。
//     fixTooBig()       fixTooSmall()を呼び出し、TooBigエラーを修正する。
//     fixTooSmall()     detectProblems()を呼び出し、TooSmallエラーを修正する。
//     detectProblems()  数値またはエラーを返す。
//
fn makeJustRight(n: u32) MyNumberError!u32 {
    return fixTooBig(n) catch |err| {
        return err;
    };
}

fn fixTooBig(n: u32) MyNumberError!u32 {
    return fixTooSmall(n) catch |err| {
        if (err == MyNumberError.TooBig) {
            return 20;
        }

        return err;
    };
}

fn fixTooSmall(n: u32) MyNumberError!u32 {
    // あらら、かなり多くの部分が欠けています！でも心配しないでください、
    // 上のfixTooBig()とほぼ同じです。
    //
    // TooSmallエラーが発生した場合、10を返すべきです。
    // その他のエラーが発生した場合、そのエラーを返すべきです。
    // それ以外の場合、u32の数値を返します。
    return detectProblems(n) catch | err | {
        if (err == MyNumberError.TooSmall) {
            return 10;
        }
        return err;
    };
}

fn detectProblems(n: u32) MyNumberError!u32 {
    if (n < 10) return MyNumberError.TooSmall;
    if (n > 20) return MyNumberError.TooBig;
    return n;
}
