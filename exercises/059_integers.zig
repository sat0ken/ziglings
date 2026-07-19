//
// Zig では整数リテラルをいくつかの便利な形式で表現できます。
// これらはすべて同じ値です：
//
//     const a1: u8 = 65;          // 10 進数
//     const a2: u8 = 0x41;        // 16 進数
//     const a3: u8 = 0o101;       // 8 進数
//     const a4: u8 = 0b1000001;   // 2 進数
//     const a5: u8 = 'A';         // ASCII コードポイントリテラル
//     const a6: u16 = '\u{0041}'; // Unicode コードポイントは最大 21 ビット
//
// 読みやすさのために数値にアンダースコアを入れることもできます：
//
//     const t1: u32 = 14_689_520 // Ford Model T の販売台数 1909-1927
//     const t2: u32 = 0xE0_24_F0 // 同じ値を 16 進数ペアで
//
// メッセージを修正してください：

const print = @import("std").debug.print;

pub fn main() void {
    const zig = [_]u8{
        'Z', // 8 進数
        'i', // 2 進数
        'g', // 16 進数
    };

    print("{s} is cool.\n", .{zig});
}
