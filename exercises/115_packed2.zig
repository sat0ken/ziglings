//
// エクササイズ030、031、108でswitch文を学びました。
// packed コンテナでも使えます：

const S = packed struct(u2) {
    a: bool,
    b: i1,
};

// `else`プロングを追加せずにコンパイルできるようにしてみましょう！

comptime {
    const s: S = .{ .a = true, .b = -1 };
    switch (s) {
        .{ .a = true, .b = -1 } => {}, // ok!
        .{ .a = true, .b = ??? },
        .{ .a = ???, .b = 0 },
        .{ .a = ???, .b = ??? },
        => @compileError("We don't want to end up here!"),
    }
}

// 見てわかるように、packed structへのswitchはかなり簡単です。
// しかしpacked unionにswitchする場合、packed unionはデバッグモードでも
// アクティブなタグを追跡しないことに気づきます！
// つまり、packed unionはビットパターンだけで比較されます（再び、整数と同様に）。

const U = packed union(u2) {
    a: u2,
    b: i2,
};

// 重複するケースを見つけて削除してください！

comptime {
    const u: U = .{ .a = 3 };
    switch (u) {
        .{ .a = 3 } => {}, // ok!
        .{ .a = 2 },
        .{ .b = 1 },
        .{ .b = -1 },
        .{ .a = 0 },
        => @compileError("We don't want to end up here!"),
    }
}

// packed unionにはアクティブなタグの概念がないため、
// そのフィールドにいつでもアクセスすることが合法です。
// これにより同じデータをシームレスに異なる視点から見るのに便利です。
//
// 以下のfloatを負にしてみましょう：

/// IEEE 754 半精度浮動小数点数
const Float = packed union(u16) {
    value: f16,
    bits: packed struct(u16) {
        mantissa: u10,
        exponent: u5,
        sign: u1,
    },
};

pub fn main() void {
    // リマインダー：floatの符号ビットがセットされている場合、その数は負です！

    var number: Float = .{ .value = 2.34 };
    number.bits.??? = ???;
    if (number.value != -2.34) {
        std.debug.print("Make it negative!\n", .{});
    }
}

// これでpacked コンテナの入門は完了です。次に個々のビットを
// 制御する必要があるときは、強力な代替手段として覚えておいてください！
//

const std = @import("std");
