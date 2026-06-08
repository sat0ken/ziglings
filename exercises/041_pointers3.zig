//
// ポインタの可変性（var と const）は、ポインタが「指している先」を変更できるかどうかを指します。
// その場所の「値」を変更できるかどうかではありません！
//
//     const locked: u8 = 5;
//     var unlocked: u8 = 10;
//
//     const p1: *const u8 = &locked;
//     var   p2: *const u8 = &locked;
//
// p1 と p2 は両方とも変更できない定数値を指しています。ただし、
// p2 は別のものを指すように変更できますが、p1 はできません！
//
//     const p3: *u8 = &unlocked;
//     var   p4: *u8 = &unlocked;
//     const p5: *const u8 = &unlocked;
//     var   p6: *const u8 = &unlocked;
//
// p3 と p4 は両方とも指している値を変更するために使用できますが、
// p3 は別のものを指すことはできません。
// 興味深いことに、p5 と p6 は p1 と p2 のように振る舞いますが、
// "unlocked" の値を指しています。これが「任意の値への定数参照を作ることができる」
// という意味です！
//
const std = @import("std");

pub fn main() void {
    var foo: u8 = 5;
    var bar: u8 = 10;

    // ポインタ "p" を定義してください。foo または bar のどちらも指すことができ、
    // かつ指している値を変更できるようにしてください！
    ??? p: ??? = undefined;

    p = &foo;
    p.* += 1;
    p = &bar;
    p.* += 1;
    std.debug.print("foo={}, bar={}\n", .{ foo, bar });
}
