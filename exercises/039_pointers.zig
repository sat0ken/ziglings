//
// これを見てください：
//
//     var foo: u8 = 5;      // fooは5
//     var bar: *u8 = &foo;  // barはポインタ
//
// ポインタとは何でしょうか？値への参照です。この例では、
// barは現在値5を格納しているメモリ空間への参照です。
//
// 上の宣言をもとにしたチートシート：
//
//     u8         u8値の型
//     foo        値5
//     *u8        u8値へのポインタの型
//     &foo       fooへの参照
//     bar        fooの値へのポインタ
//     bar.*      値5（barが指す"デリファレンスされた"値）
//
// ポインタがなぜ便利なのかはすぐにわかります。まずは
// この例を動かせるか試してみましょう！
//
const std = @import("std");

pub fn main() void {
    var num1: u8 = 5;
    const num1_pointer: *u8 = &num1;

    var num2: u8 = undefined;

    // num1_pointerを使ってnum2を5にしてください！
    //（上の「チートシート」を参考にしてください。）
    num2 = ???;

    std.debug.print("num1: {}, num2: {}\n", .{ num1, num2 });
}
