//
// 信じられないかもしれませんが、プログラムで何かがうまくいかないことがあります。
//
// Zigでは、エラーは値です。エラーには名前がついており、何が問題かを特定できます。
// エラーは「エラーセット」の中に作成されます。エラーセットとは
// 名前付きエラーのコレクションです。
//
// エラーセットの始まりはありますが、"TooSmall"という条件が
// 欠けています。必要な場所に追加してください！
const MyNumberError = error{
    TooBig,
    ???,
    TooFour,
};

const std = @import("std");

pub fn main() void {
    const nums = [_]u8{ 2, 3, 4, 5, 6 };

    for (nums) |n| {
        std.debug.print("{}", .{n});

        const number_error = numberFail(n);

        if (number_error == MyNumberError.TooBig) {
            std.debug.print(">4. ", .{});
        }
        if (???) {
            std.debug.print("<4. ", .{});
        }
        if (number_error == MyNumberError.TooFour) {
            std.debug.print("=4. ", .{});
        }
    }

    std.debug.print("\n", .{});
}

// この関数がMyNumberErrorエラーセットの任意のメンバーを返せることに注目してください。
fn numberFail(n: u8) MyNumberError {
    if (n > 4) return MyNumberError.TooBig;
    if (n < 4) return MyNumberError.TooSmall; // <---- これはサービスです！
    return MyNumberError.TooFour;
}
