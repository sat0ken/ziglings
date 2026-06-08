//
// 素晴らしいニュースです！これでZigの「本物の」Hello Worldプログラムを
// 理解できるだけの知識が身につきました。このプログラムはシステムの
// 標準出力リソースを使用します…失敗する可能性があります！
//
const std = @import("std");

// このmain()の定義が"void"だけでなく"!void"を返すようになっていることに注目してください。
// 特定のエラー型がないため、Zigがエラー型を推論します。
// main()の場合はこれで適切ですが、状況によっては関数の扱いが
// 難しくなったり（関数ポインタ）、不可能になったりする（再帰）場合があります。
//
// 詳細はこちらで確認できます：
// https://ziglang.org/documentation/master/#Inferred-Error-Sets
//
pub fn main(init: std.process.Init) !void {
    // 入出力操作のインスタンス。詳細は後で学びます。
    const io = init.io;

    // 標準出力のWriterを取得します...
    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    // ...そしてprint()できるようにインターフェイスを取り出します。
    const stdout = &stdout_writer.interface;

    // std.debug.print()と異なり、標準出力のwriterはエラーで失敗する
    // 可能性があります。_どんな_エラーかは気にせず、
    // それをmain()の戻り値として渡せるようにしたいです。
    //
    // これを一つの文で実現できる方法を先ほど学びました。
    stdout.print("Hello world!\n", .{});
}
