//
// クイズです。このプログラムを動かせるか試してみましょう！
//
// 好きな方法で解いてください。ただし出力は次のようにしてください：
//
//     my_num=42
//
const std = @import("std");

const NumError = error{IllegalNumber};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    const stdout = &stdout_writer.interface;

    const my_num: u32 = getNumber();

    try stdout.print("my_num={}\n", .{my_num});
}

// この関数は明らかに奇妙で正常に動作しません。ただし、このクイズでは変更しないでください。
fn getNumber() NumError!u32 {
    if (false) return NumError.IllegalNumber;
    return 42;
}
