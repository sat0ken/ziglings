//
// メソッドの仕組みを理解したので、Elephant メソッドを使って
// 象たちをもう少し助けてみましょう。
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    visited: bool = false,

    // 新しい Elephant メソッド！
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // 「orelse unreachable」を意味します
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

    pub fn visit(self: *Elephant) void {
        self.visited = true;
    }

    pub fn print(self: *Elephant) void {
        // 象の文字と [v]isited を表示します
        const v: u8 = if (self.visited) 'v' else ' ';
        std.debug.print("{u}{u} ", .{ self.letter, v });
    }
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // 象たちをリンクして、それぞれのしっぽが次を「指す」ようにします。
    elephantA.tail = &elephantB;
    elephantB.tail = &elephantC;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// この関数は最初の象から始めてしっぽをたどりながら、
// すべての象を一度だけ訪問します。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (true) {
        e.print();
        e.visit();

        // 次の象を取得するか停止します：
        // ここではどのメソッドを使えばよいでしょうか？
        e = if (e.hasTail()) e.getTail() else break;
    }
}

// Zig の enum もメソッドを持てます！このコメントはもともと
// 実際のコードで enum メソッドの例を見つけた人を募集していました。
// 最初の 5 つのプルリクエストが受理され、以下にまとめられています：
//
// 1) drforester - Zig のソースコードで見つけました：
// https://github.com/ziglang/zig/blob/041212a41cfaf029dc3eb9740467b721c76f406c/src/Compilation.zig#L2495
//
// 2) bbuccianti - 見つけました！
// https://github.com/ziglang/zig/blob/6787f163eb6db2b8b89c2ea6cb51d63606487e12/lib/std/debug.zig#L477
//
// 3) GoldsteinE - たくさん見つけました、これはそのひとつ
// https://github.com/ziglang/zig/blob/ce14bc7176f9e441064ffdde2d85e35fd78977f2/lib/std/target.zig#L65
//
// 4) SpencerCDixon - この言語を気に入っています :-)
// https://github.com/ziglang/zig/blob/a502c160cd51ce3de80b3be945245b7a91967a85/src/zir.zig#L530
//
// 5) tomkun - こちらも別の enum メソッドです
// https://github.com/ziglang/zig/blob/4ca1f4ec2e3ae1a08295bc6ed03c235cb7700ab9/src/codegen/aarch64.zig#L24
