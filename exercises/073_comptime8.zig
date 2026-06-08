//
// 実は、任意の式の前に 'comptime' を置くことで、
// コンパイル時に強制的に実行させることができます。
//
// 関数を実行する：
//
//     comptime llama();
//
// 値を取得する：
//
//     bar = comptime baz();
//
// ブロック全体を実行する：
//
//     comptime {
//         bar = baz + biff();
//         llama(bar);
//     }
//
// ブロックから値を取得する：
//
//     var llama = comptime bar: {
//         const baz = biff() + bonk();
//         break :bar baz;
//     }
//
const print = @import("std").debug.print;

const llama_count = 5;
const llamas = [llama_count]u32{ 5, 10, 15, 20, 25 };

pub fn main() void {
    // 最後のラマを取得しようとしました。アサーションが
    // 失敗しなくなるようにこの単純なミスを修正してください。
    const my_llama = getLlama(5);

    print("My llama value is {}.\n", .{my_llama});
}

fn getLlama(i: usize) u32 {
    // この関数の先頭にガードの assert() を置いて
    // ミスを防いでいます。ここでの 'comptime' キーワードは、
    // コンパイル時にミスが検出されることを意味します！
    //
    // 'comptime' がなくても機能しますが、アサーションは
    // PANICで実行時に失敗します。それほど良くありません。
    //
    // 残念ながら、'i' パラメータがコンパイル時に既知であることを
    // 保証する必要があるため、今すぐエラーが発生します。
    // これを実現するために上の 'i' パラメータに何ができますか？
    comptime assert(i < llama_count);

    return llamas[i];
}

// 余談：この assert() 関数は Zig 標準ライブラリの
// std.debug.assert() と同一です。
fn assert(ok: bool) void {
    if (!ok) unreachable;
}
//
// ボーナス余談：この演習で 'foo' のすべてのインスタンスを
// 誤って 'llama' に置き換えてしまいましたが、後悔はしていません！
