//
// タグ付きユニオンを使うと、さらに良くなります！別の enum が必要ない場合、
// ユニオンと一緒に推論される enum を一か所で定義できます。
// タグの型の代わりに 'enum' キーワードを使うだけです：
//
//     const Foo = union(enum) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// Insect を変換しましょう。Zoraptera 博士が既に
// 明示的な InsectStat enum を削除してくれました！
//
const std = @import("std");

const Insect = union(enum) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 17 };

    std.debug.print("Insect report! ", .{});

    printInsect(ant);
    printInsect(bee);

    std.debug.print("\n", .{});
}

fn printInsect(insect: Insect) void {
    switch (insect) {
        .still_alive => |a| std.debug.print("Ant alive is: {}. ", .{a}),
        .flowers_visited => |f| std.debug.print("Bee visited {} flowers. ", .{f}),
    }
}

// 推論された enum は素晴らしいもので、enum とユニオンの関係という
// 氷山の一角を表しています。実際にユニオンを enum に強制変換することも
// できます（ユニオンからアクティブなフィールドを enum として取得できます）。
// さらに驚くことに、enum をユニオンに強制変換することもできます！
// ただし、それはユニオン型が void のようなゼロビット型の場合のみ機能します。
//
// タグ付きユニオンは、コンピュータサイエンスのほとんどのアイデアと同様に、
// 1960 年代にまで遡る長い歴史があります。しかし、特にシステムレベルの
// プログラミング言語では最近になってメインストリームになりつつあります。
// 「バリアント」、「直和型」、あるいは「enum」とも呼ばれることがあります！
