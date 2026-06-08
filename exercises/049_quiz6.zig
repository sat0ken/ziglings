//
//    「幹としっぽは
//      便利なものだ」
//
//     Holding Hands より
//       作者：Lenore M. Link
//
// しっぽが理解できたので、幹も実装できますか？
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null,
    trunk: ?*Elephant = null,
    visited: bool = false,

    // 象のしっぽメソッド！
    pub fn getTail(self: *Elephant) *Elephant {
        return self.tail.?; // 「orelse unreachable」を意味します
    }

    pub fn hasTail(self: *Elephant) bool {
        return (self.tail != null);
    }

    // 象の幹メソッドをここに書きましょう！
    // ---------------------------------------------------

    ???

    // ---------------------------------------------------

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

    // 象たちをリンクして、それぞれの幹が前を「指す」ようにします。
    elephantB.trunk = &elephantA;
    elephantC.trunk = &elephantB;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// この関数は象たちをしっぽから幹へと、2 回訪問します。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    // しっぽをたどります！
    while (true) {
        e.print();
        e.visit();

        // 次の象を取得するか停止します。
        if (e.hasTail()) {
            e = e.getTail();
        } else {
            break;
        }
    }

    // 幹をたどります！
    while (true) {
        e.print();

        // 前の象を取得するか停止します。
        if (e.hasTrunk()) {
            e = e.getTrunk();
        } else {
            break;
        }
    }
}
