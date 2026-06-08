//
// スライスを使って特定の長さを指定することで、
// 多アイテムポインタから出力可能な文字列を取得できました。
//
// しかし、強制変換で「失った」センチネルを
// センチネル終端ポインタに戻すことはできるでしょうか？
//
// はい、できます。Zigの @ptrCast() 組み込み関数で
// これができます。シグネチャを確認してください：
//
//     @ptrCast(value: anytype) anytype
//
// 長さを必要とせずに同じ多アイテムポインタの問題を
// 解決するために使えるか試してみましょう。
//
const print = @import("std").debug.print;

pub fn main() void {
    // 再び、センチネル終端の文字列を多アイテムポインタに
    // 強制変換しました。長さもセンチネルもありません。
    const data: [*]const u8 = "Weird Data!";

    // 'data' を 'printable' にキャストしてください：
    const printable: [*:0]const u8 = ???;

    print("{s}\n", .{printable});
}
