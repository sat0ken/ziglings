//
//    「私たちは無限の暗黒の海の中に
//      浮かぶ穏やかな無知の島に住んでいる。
//      遠くへ航海することは
//      私たちには許されていなかった。」
//
//     クトゥルフの呼び声 より
//       作者：H. P. ラヴクラフト
//
// Zig には「値なし」を表す方法が少なくとも 4 つあります：
//
// * undefined
//
//       var foo: u8 = undefined;
//
//       "undefined" は値として考えるべきではなく、コンパイラに対して
//       「まだ」値を割り当てていないことを伝える方法です。
//       任意の変数を undefined に設定できますが、値を割り当てる前に
//       読み取ろうとするのは「常に」間違いです。
//
// * null
//
//       var foo: ?u8 = null;
//
//       "null" プリミティブ値は「値なし」を意味する値「そのもの」です。
//       これは通常、上記の ?u8 のような optional 型と一緒に使用されます。
//       foo が null の場合、それは u8 型の値ではありません。
//       foo に「値がない」ことを割り当てたことを意味します！
//
// * error
//
//       var foo: MyError!u8 = BadError;
//
//       エラーは null に非常によく似ています。エラーは値「ですが」、
//       通常は探していた「本当の値」が存在しないことを示します。
//       「値なし」の代わりに、エラーがあります。
//       MyError!u8 というエラーユニオン型の例は、foo が u8 値か
//       MyError エラーのどちらかを保持することを意味します。
//
// * void
//
//       var foo: void = {};
//
//       "void" は値ではなく「型」です。ゼロビット型（まったく容量を取らず
//       意味的な値のみを持つ型）の中で最もよく使われます。実行可能コードに
//       コンパイルされると、ゼロビット型はまったくコードを生成しません。
//       上の例では void 型の変数 foo が空の式の値を代入されています。
//       void は何も返さない関数の戻り値の型として見ることの方が
//       はるかに一般的です。
//
// Zig に「値なし」を表すこれほど多くの方法があるのは、
// それぞれが目的を持っているためです。簡単にまとめると：
//
//   * undefined - まだ値がない、まだ読めない
//   * null      - 「値なし」という明示的な値がある
//   * errors    - 何かがうまくいかなかったため値がない
//   * void      - ここには永遠に値が来ない
//
// ネクロノミコンの呪われた引用を表示するために、
// 各 ??? に正しい「値なし」を使ってください。...もし勇気があれば。
//
const std = @import("std");

const Err = error{Cthulhu};

pub fn main() void {
    var first_line1: *const [16]u8 = ???;
    first_line1 = "That is not dead";

    var first_line2: Err!*const [21]u8 = ???;
    first_line2 = "which can eternal lie";

    // エラーユニオン文字列には "{!s}" フォーマットが必要です。
    std.debug.print("{s} {!s} / ", .{ first_line1, first_line2 });

    printSecondLine();
}

fn printSecondLine() ??? {
    var second_line2: ?*const [18]u8 = ???;
    second_line2 = "even death may die";

    std.debug.print("And with strange aeons {s}.\n", .{second_line2.?});
}
