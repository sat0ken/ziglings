const std = @import("std");
const print = std.debug.print;

// Zigのパワーを（悪）用して動物のハイブリッド生物を作ります！
// GatorMouseはどんな見た目でしょうか？キャー。
//
// 代わりに MouseLlama を試してみましょう。
//
// コンパイル時に実行される関数を作って、希望する生物を
// 説明する短いコードを受け取ります。Mouseは"m"で表され、
// Llamaは"lm"です。MouseLlamaのハイブリッドなら"mlm"で
// 表されます。

const Animal = enum {
    Mouse,
    Llama,
    Gator,
};

// makeCreature はハイブリッド生物を構成する動物の数（ペンの
// 大きさを知るため）と "mlm" のようなフォーマット文字列を受け取ります。
fn makeCreature(comptime count: usize, comptime fmt: []const u8) [count]Animal {

    // すべての動物が1文字で表されるわけではないため、
    // 進むにつれて状態を追跡する必要があります。例えば、
    // "m"を見たとき、それは新しいMouseなのか、Llamaの末尾なのか？
    const State = enum {
        start, // 新しい動物を始める準備ができています。
        l, // "l"を見たことを意味します。"m"を見たらLlamaだと分かります。
    };
    var state = State.start;

    // 生物を表す動物の配列を返します。（これが
    // 'count' パラメータが本当に必要な理由です。配列にはサイズが必要です。）
    var animals: [count]Animal = undefined;
    var next_animal: usize = 0;

    inline for (fmt) |char| {

        // makeCreature で変数をデバッグする必要がある場合は、
        // ここに @compileLog() 呼び出しを追加するのが良い場所です...
        // （main() を見た後でここに戻ってきてください。）

        switch (state) {
            .start => switch (char) {
                // Llamaの始まりを見ました。
                'l' => state = .l,

                // Mouseは小さいです。"m"は完全なMouseです。
                'm' => {
                    animals[next_animal] = .Mouse;
                    next_animal += 1;
                },

                // @compileError は何かがおかしい場合に
                // ビルドを即座に停止させます。@compileLog に似ていますが、
                // 値を調べる代わりにメッセージを出力します。
                //
                // Gatorはどうなると思いますか？他の動物と
                // 結合するのか、それともエラーになるのか？
                'g' => ???,

                else => @compileError(std.fmt.comptimePrint("No animal starts with '{c}'!", .{char})),
            },

            .l => switch (char) {
                // Llamaの末尾を見ました。
                'm' => {
                    animals[next_animal] = .Llama;
                    next_animal += 1;
                    // ここに何かが足りません。Llamaを完成させた後、
                    // 新しい動物を_始める_準備をする必要があります...
                    ???
                },

                else => @compileError("Only llamas start with 'l'!"),
            },
        }
    }

    if (state != .start) {
        @compileError("Oh no, an incomplete llama!");
    }
    if (next_animal != count) {
        @compileError("Creature is missing an animal (format string too short).");
    }

    return animals;
}

pub fn main() void {
    // 上の ??? マークを修正したら、この makeCreature 呼び出しは
    // main の外に移動しないと成功しません。コンパイル時に実行されるためです。
    //
    // ここでの呼び出しでは、Zig は実行時に生物を作ろうとし、
    // 興味深いエラーが発生します。
    //
    // 状態が混乱したと思うかもしれませんが、makeCreature で
    // @compileLog を使っていくつかの変数を確認すると、
    // Zig が comptime 値を "[runtime value]" と比較しようとしており、
    // それは決して一致しないことが分かります。
    //
    // makeCreature 内の2つの変数に "comptime" を追加することで
    // これを解決できます...
    const creature = makeCreature(2, "mlm");

    for (creature) |animal| {
        // @tagName は enum のどのバリアントを持っているかを表す
        // 文字列を返します。これにより、ここで繰り返すことなく
        // 動物の名前を出力できます。
        print("{s}", .{@tagName(animal)});
    }
    print(" joins the crew!", .{});
}
