//
// 何らかの理由で命名規則に従わない識別子を
// 作成する必要がある場合があります：
//
//     const 55_cows: i32 = 55; // 違法：数字で始まっている
//     const isn't true: bool = false; // 違法：これは一体何？！
//
// 通常の状況でこれらのいずれかを作成しようとすると、
// 特別なプログラム識別子構文セキュリティチーム（PISST）が
// あなたの家にやってきて連行します。
//
// ありがたいことに、Zigにはこれらの奇妙な識別子を
// 当局の目を欺いてプログラムに忍び込ませる方法があります：
// @"" 識別子クォート構文です。
//
//     @"foo"
//
// これらの逃亡中の識別子を安全にプログラムに
// 密輸するのを手伝ってください：
//
const print = @import("std").debug.print;

pub fn main() void {
    const 55_cows: i32 = 55;
    const isn't true: bool = false;

    print("Sweet freedom: {}, {}.\n", .{
        55_cows,
        isn't true,
    });
}
