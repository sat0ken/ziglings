//
// こんな風にif/else文を式として使うことを覚えていますか？
//
//     var foo: u8 = if (true) 5 else 0;
//
// Zigではforループやwhileループも式として使えます。
//
// 関数の'return'と同様に、breakを使って
// ループブロックから値を返すことができます：
//
//     break true; // ブロックからboolean値を返す
//
// しかし、break文に到達しなかった場合、ループから
// 返される値は何でしょうか？デフォルト式が必要です。
// ありがたいことに、Zigのループには'else'節もあります！
// 予想通り、'else'節が評価されるのは：1) 'while'条件が
// false になったとき、または 2) 'for'ループのアイテムが
// なくなったときです。
//
//     const two: u8 = while (true) break 2 else 0;         // 2
//     const three: u8 = for ([1]u8{1}) |f| break 3 else 0; // 3
//
// else節を指定しない場合、空のものが自動的に提供され、
// void型として評価されます。これはおそらく望んでいる
// 結果ではありません。ループを式として使う場合、
// else節は必須だと考えてください。
//
//     const four: u8 = while (true) {
//         break 4;
//     };               // <-- エラー！ここに暗黙の 'else void' があります！
//
// これを踏まえて、このプログラムの問題を
// 修正できるか試してみましょう。
//
const print = @import("std").debug.print;

pub fn main() void {
    const langs: [6][]const u8 = .{
        "Erlang",
        "Algol",
        "C",
        "OCaml",
        "Zig",
        "Prolog",
    };

    // 3文字の名前を持つ最初の言語を見つけて
    // forループから返してみましょう。
    const current_lang: ?[]const u8 = for (langs) |lang| {
        if (lang.len == 3) break lang;
    };

    if (current_lang) |cl| {
        print("Current language: {s}\n", .{cl});
    } else {
        print("Did not find a three-letter language name. :-(\n", .{});
    }
}
