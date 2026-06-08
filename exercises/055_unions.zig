//
// ユニオンは同じメモリアドレスに異なる型とサイズのデータを保存できます。
// なぜこれが可能かというと、コンパイラが保存したい最大のものに対して
// 十分なメモリを確保するからです。
//
// この例では、Foo のインスタンスは u8 を保存している場合でも
// 常に u64 のメモリを占有します。
//
//     const Foo = union {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// 構文は構造体とまったく同じように見えますが、Foo は small か medium か
// large のどれか一つの値しか保持できません。フィールドがアクティブになると、
// 他の非アクティブなフィールドにはアクセスできません。アクティブなフィールドを
// 変更するには、新しいインスタンスを丸ごと代入します：
//
//     var f = Foo{ .small = 5 };
//     f.small += 5;                  // OK
//     f.medium = 5432;               // エラー！
//     f = Foo{ .medium = 5432 };     // OK
//
// ユニオンはメモリ内のスペースを「再利用」できるため、メモリを節約できます。
// また、一種の原始的なポリモーフィズムも提供します。ここでは fooBar() が
// 保持する符号なし整数のサイズに関係なく Foo を受け取れます：
//
//     fn fooBar(f: Foo) void { ... }
//
// でも、fooBar() はどのフィールドがアクティブかどうやって知るのでしょうか？
// Zig には管理する素晴らしい方法がありますが、今のところ手動でやるしかありません。
//
// このプログラムを動作させてみましょう！
//
const std = @import("std");

// 簡単なエコシステムシミュレーションを書き始めました。
// 昆虫はミツバチかアリのどちらかで表されます。ミツバチはその日に
// 訪れた花の数を保存し、アリはまだ生きているかどうかを保存します。
const Insect = union {
    flowers_visited: u16,
    still_alive: bool,
};

// 昆虫の種類を指定する必要があるため、enum を使います（覚えていますか？）。
const AntOrBee = enum { a, b };

pub fn main() void {
    // アリとミツバチを一匹ずつ作ってテストします：
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 15 };

    std.debug.print("Insect report! ", .{});

    // おっと！ここに間違いがあります。
    printInsect(ant, AntOrBee.c);
    printInsect(bee, AntOrBee.c);

    std.debug.print("\n", .{});
}

// 風変わりな Zoraptera 博士は、昆虫を表示するのに
// 1 つの関数しか使えないと言っています。博士は小柄で
// 時々わかりにくいですが、私たちは疑問を呈しません。
fn printInsect(insect: Insect, what_it_is: AntOrBee) void {
    switch (what_it_is) {
        .a => std.debug.print("Ant alive is: {}. ", .{insect.still_alive}),
        .b => std.debug.print("Bee visited {} flowers. ", .{insect.flowers_visited}),
    }
}
