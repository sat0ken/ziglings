//
// Optional 型が手に入ったので、構造体に適用してみましょう。
// 前回の象の話では、最後のしっぽが最初の象に戻る「円環」を作るために
// 3 頭すべてをリンクしなければなりませんでした。それは「別の象を指さない
// しっぽ」という概念がなかったためです！
//
// 便利な `.?` ショートカットも紹介します：
//
//     const foo = bar.?;
//
// これは次と同じです
//
//     const foo = bar orelse unreachable;
//
// optional 値が存在するかどうかに基づいて制御フローを変更するために
// このショートカットをどこで使っているか確認してみてください。
//
// では、象のしっぽを optional にしてみましょう！
//
const std = @import("std");

const Elephant = struct {
    letter: u8,
    tail: ?*Elephant = null, // Hmm... tail には何かが必要です...
    visited: bool = false,
};

pub fn main() void {
    var elephantA = Elephant{ .letter = 'A' };
    var elephantB = Elephant{ .letter = 'B' };
    var elephantC = Elephant{ .letter = 'C' };

    // 象たちをリンクして、それぞれのしっぽが次を「指す」ようにします。
    linkElephants(&elephantA, &elephantB);
    linkElephants(&elephantB, &elephantC);

    // `linkElephants` は存在しない象をリンクしようとするとプログラムを停止します！
    // コメントを外して何が起きるか見てみましょう。
    // const missingElephant: ?*Elephant = null;
    // linkElephants(&elephantC, missingElephant);

    visitElephants(&elephantA);

    std.debug.print("\n", .{});
}

// e1 と e2 が象への有効なポインタであれば、
// この関数は e1 のしっぽが e2 を「指す」ように象をリンクします。
fn linkElephants(e1: ?*Elephant, e2: ?*Elephant) void {
    e1.?.tail = e2.?;
}

// この関数は最初の象から始めてしっぽをたどりながら、
// すべての象を一度だけ訪問します。
fn visitElephants(first_elephant: *Elephant) void {
    var e = first_elephant;

    while (!e.visited) {
        std.debug.print("Elephant {u}. ", .{e.letter});
        e.visited = true;

        // 別の要素を指さないしっぽに出会ったら停止するべきです。
        // それを実現するために何を書けばよいでしょうか？

        // ヒント：`.?` と似たようなことをしたいのですが、
        // プログラムを終了させる代わりにループを抜け出したいです...
        e = e.tail orelse break;
    }
}
