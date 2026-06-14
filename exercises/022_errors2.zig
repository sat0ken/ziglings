//
// エラーが多く使われるのは、値を期待しているが何かがうまくいかない
// という状況です。次の例を見てみましょう：
//
//     var text: Text = getText("foo.txt");
//
// getText()が"foo.txt"を見つけられない場合はどうなるでしょう？
// Zigではどのように表現するのでしょうか？
//
// Zigでは「エラーユニオン」と呼ばれるものを作ることができます。
// エラーユニオンとは、通常の値またはセットからのエラーのどちらかになる値です：
//
//     var text: MyErrorSet!Text = getText("foo.txt");
//
// まずは、エラーユニオンを作ってみましょう！
//
const std = @import("std");

const MyNumberError = error{TooSmall};

pub fn main() void {
    var my_number: MyNumberError!u8 = 5;

    // my_numberは数値またはエラーのどちらかを格納する必要があります。
    // 上で正しい型を設定できますか？
    my_number = MyNumberError.TooSmall;

    std.debug.print("I compiled!\n", .{});
}
