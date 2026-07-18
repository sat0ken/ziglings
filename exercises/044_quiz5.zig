//
//    「象たちが
//      道を歩いて行く
//
//      しっぽをつかんで
//      手をつないで。」
//
//     Holding Hands より
//       作者：Lenore M. Link
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: *Elephant = undefined,
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    // （ここに Elephant B を追加してください！）
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // 象たちをリンクして、それぞれのしっぽが次の象を「指す」ようにします。
    // A->B->C->A... という円を作ります。
    elephantA.tail = &elephantB;
    // （ここで Elephant B のしっぽを Elephant C にリンクしてください！）
    elephantB.tail = &elephantC;
    elephantC.tail = &elephantA;

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// この関数は最初の象から始めてしっぽをたどりながら、
// すべての象を一度だけ訪問します。
// 象を「訪問済み」としてマーク（visited=true を設定）しなければ、
// 無限ループになってしまいます！
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;
        e = e.tail;
    }
}
