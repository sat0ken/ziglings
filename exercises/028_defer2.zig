//
// "defer"の動作がわかったところで、もっと面白いことをやってみましょう。
//
const std = @import("std");

pub fn main() void {
    const animals = [_]u8{ 'g', 'c', 'd', 'd', 'g', 'z' };

    for (animals) |a| printAnimal(a);

    std.debug.print("done.\n", .{});

    std.debug.print("Answer to everything? {d}\n", .{calculateTheUltimateQuestionOfLife()});
}

// この関数は動物の名前をカッコ付きで"(Goat) "のように出力する_はず_ですが、
// この関数は4つの異なる場所で返ることができるにもかかわらず、
// 閉じカッコを何とか出力する必要があります！
fn printAnimal(animal: u8) void {
    std.debug.print("(", .{});

    std.debug.print(") ", .{}); // <---- どうやって?!

    if (animal == 'g') {
        std.debug.print("Goat", .{});
        return;
    }
    if (animal == 'c') {
        std.debug.print("Cat", .{});
        return;
    }
    if (animal == 'd') {
        std.debug.print("Dog", .{});
        return;
    }

    std.debug.print("Unknown", .{});
}

// この関数は生命、宇宙、そして万物についての究極の疑問の答えを
// 計算するはずですが、より多くのデータを収集するため、
// できる限り未来まで延期する必要があります。
//
// 単一ブロック内に複数のdeferがある場合、逆順に実行されます。
// この例は少し馬鹿げているように見えますが、例えば
// 要素を先に解放する必要があるコンテナを解放する場合などに
// 重要な知識です。
fn calculateTheUltimateQuestionOfLife() u32 {
    var x: u32 = 100;

    // 42という答えを得るためにステートメントを並べ替えてみてください
    {
        defer x = x / 10;
        defer x = x + 11;
        defer x = x * 2;
    }

    return x;
}
