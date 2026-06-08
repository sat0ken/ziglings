//
// エラーユニオンを扱う方法の一つは、エラーを「catch」して
// デフォルト値に置き換えることです。
//
//     foo = canFail() catch 6;
//
// canFail()が失敗すると、fooは6になります。
//
const std = @import("std");

const MyNumberError = error{TooSmall};

pub fn main() void {
    const a: u32 = addTwenty(44) catch 22;
    const b: u32 = addTwenty(4) ??? 22;

    std.debug.print("a={}, b={}\n", .{ a, b });
}

// この関数の戻り値の型を指定してください。
// ヒント：エラーユニオンになります。
fn addTwenty(n: u32) ??? {
    if (n < 5) {
        return MyNumberError.TooSmall;
    } else {
        return n + 20;
    }
}
