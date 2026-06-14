//
// 配列の基本を学びましょう。配列はこのように宣言します：
//
//   var foo: [3]u32 = [3]u32{ 42, 108, 5423 };
//
// Zigが配列のサイズを推論できる場合、サイズに '_' を使えます。
// また、値の型もZigに推論させることができるので、
// 宣言がずっとシンプルになります。
//
//   var foo = [_]u32{ 42, 108, 5423 };
//
// 配列の値を取得するには array[index] 記法を使います：
//
//     const bar = foo[2]; // 5423
//
// 配列の値を設定するには array[index] 記法を使います：
//
//     foo[2] = 16;
//
// 配列の長さを取得するには len プロパティを使います：
//
//     const length = foo.len;
//
const std = @import("std");

pub fn main() void {
    // （問題1）
    // この "const" は後で問題を引き起こします - 何が問題か分かりますか？
    // どう修正すればよいでしょうか？
    var some_primes = [_]u8{ 1, 3, 5, 7, 11, 13, 17, 19 };

    // 値は '[]' 記法で設定できます。
    // 例：この行は最初の素数を2に変更します（正しい値です）：
    some_primes[0] = 2;

    // 値は '[]' 記法でアクセスすることもできます。
    // 例：この行は最初の素数を "first" に格納します：
    const first = some_primes[0];

    // （問題2）
    // この式を完成させる必要があります。上の例を参考にして、
    // "fourth" に some_primes 配列の4番目の要素を設定してください：
    const fourth = some_primes[3];

    // （問題3）
    // len プロパティを使って配列の長さを取得してください：
    const length = some_primes.len;

    std.debug.print("First: {}, Fourth: {}, Length: {}\n", .{
        first, fourth, length,
    });
}
