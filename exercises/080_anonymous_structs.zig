//
// 構造体型は名前を付けるまで常に「匿名」です：
//
//     struct {};
//
// これまで、このように構造体型に名前を付けてきました：
//
//     const Foo = struct {};
//
// * @typeName(Foo) の値は "<filename>.Foo" です。
//
// 構造体は関数から返す際にも名前が付きます：
//
//     fn Bar() type {
//         return struct {};
//     }
//
//     const MyBar = Bar();  // 構造体型を格納する
//     const bar = Bar() {}; // 構造体のインスタンスを作成する
//
// * @typeName(Bar()) の値は "<filename>.Bar()" です。
// * @typeName(MyBar) の値は "<filename>.Bar()" です。
// * @typeName(@TypeOf(bar)) の値は "<filename>.Bar()" です。
//
// 完全に匿名の構造体を持つこともできます。
// @typeName(struct {}) の値は "<filename>.<function>__struct_<nnn>" です。
//
const print = @import("std").debug.print;

// この関数は匿名の構造体型を返すことでジェネリックな
// データ構造を作成します（関数から返された後は
// もはや匿名ではなくなります）。
fn Circle(comptime T: type) type {
    return struct {
        center_x: T,
        center_y: T,
        radius: T,
    };
}

pub fn main() void {
    //
    // これらの2つの変数初期化式を完成させて、
    // 以下の値を保持できる circle 構造体型の
    // インスタンスを作成してみましょう：
    //
    // * circle1 は i32 整数を保持する
    // * circle2 は f32 浮動小数点数を保持する
    //
    const circle1 = ??? {
        .center_x = 25,
        .center_y = 70,
        .radius = 15,
    };

    const circle2 = ??? {
        .center_x = 25.234,
        .center_y = 70.999,
        .radius = 15.714,
    };

    print("[{s}: {},{},{}] ", .{
        stripFname(@typeName(@TypeOf(circle1))),
        circle1.center_x,
        circle1.center_y,
        circle1.radius,
    });

    print("[{s}: {d:.1},{d:.1},{d:.1}]\n", .{
        stripFname(@typeName(@TypeOf(circle2))),
        circle2.center_x,
        circle2.center_y,
        circle2.radius,
    });
}

// 演習065での「自己陶酔的な修正」を覚えていますか？
// ここでも同じことをします：ハードコードされたスライスを使って
// 型名を返します。出力を見やすくするためだけです。
// 自分の虚栄心を満たしてください。プログラマーは美しい。
fn stripFname(mytype: []const u8) []const u8 {
    return mytype[22..];
}
// 上記は「本物の」プログラムではすぐに赤信号になるでしょう。
