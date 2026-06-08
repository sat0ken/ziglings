//
// 匿名構造体の値リテラル（構造体の型と混同しないでください）
// は '.{}' 構文を使用します：
//
//     .{
//          .center_x = 15,
//          .center_y = 12,
//          .radius = 6,
//     }
//
// これらのリテラルは常にコンパイル時に完全に評価されます。
// 上記の例は、前の演習の "circle struct" の i32 バリアントに
// 強制変換できます。
//
// または、次の例のように完全に匿名のままにすることもできます：
//
//     fn bar(foo: anytype) void {
//         print("a:{} b:{}\n", .{foo.a, foo.b});
//     }
//
//     bar(.{
//         .a = true,
//         .b = false,
//     });
//
// 上記の例は "a:true b:false" と出力します。
//
const print = @import("std").debug.print;

pub fn main() void {
    printCircle(.{
        .center_x = @as(u32, 205),
        .center_y = @as(u32, 187),
        .radius = @as(u32, 12),
    });
}

// 円を表す匿名構造体を出力するこの関数を完成させてください。
fn printCircle(???) void {
    print("x:{} y:{} radius:{}\n", .{
        circle.center_x,
        circle.center_y,
        circle.radius,
    });
}
