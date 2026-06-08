//
// 演習55と56でユニオンを使って構築したアリとミツバチのシミュレーターを
// 覚えていますか？そこでは、ユニオンが異なるデータ型を統一的に
// 扱えることを示しました。
//
// タグ付きユニオンを使ってアリ*またはミツバチのステータスを
// 出力する単一関数を作成するという便利な機能がありました：
//
//   switch (insect) {
//      .still_alive => ...      // （アリの情報を出力）
//      .flowers_visited => ...  // （ミツバチの情報を出力）
//   }
//
// さて、そのシミュレーションは順調に動いていましたが、
// 仮想の庭に新しい昆虫、バッタが現れました！
//
// Zoraptera博士はバッタのコードを追加しようとしましたが、
// 怒った唸り声を上げてキーボードから離れました。彼女は、
// 各昆虫のコードが一箇所にあり、各昆虫の出力コードが別の場所にある
// という構造は、シミュレーションが数百種類の異なる昆虫に
// 拡張されるときに保守が大変になることに気づいたのです。
//
// ありがたいことに、Zig にはこの問題から抜け出すために使える
// 別のコンパイル時機能、'inline else' があります。
//
// この冗長なコードを：
//
//   switch (thing) {
//       .a => |a| special(a),
//       .b => |b| normal(b),
//       .c => |c| normal(c),
//       .d => |d| normal(d),
//       .e => |e| normal(e),
//       ...
//   }
//
// 以下のように置き換えられます：
//
//   switch (thing) {
//       .a => |a| special(a),
//       inline else => |t| normal(t),
//   }
//
// 一部のケースを特別扱いして、残りのマッチングはZigに任せられます。
//
// この機能を使って、単一の統一された 'print()' 関数を持つ
// Insect ユニオンを作ることにしました。すべての昆虫は
// 自分自身を出力する責任を持てます。そして Zoraptera 博士は
// 落ち着いて家具を噛むのをやめられます。
//
const std = @import("std");

const Ant = struct {
    still_alive: bool,

    pub fn print(self: Ant) void {
        std.debug.print("Ant is {s}.\n", .{if (self.still_alive) "alive" else "dead"});
    }
};

const Bee = struct {
    flowers_visited: u16,

    pub fn print(self: Bee) void {
        std.debug.print("Bee visited {} flowers.\n", .{self.flowers_visited});
    }
};

// 新しいバッタです。各昆虫に print メソッドも追加しました。
const Grasshopper = struct {
    distance_hopped: u16,

    pub fn print(self: Grasshopper) void {
        std.debug.print("Grasshopper hopped {} meters.\n", .{self.distance_hopped});
    }
};

const Insect = union(enum) {
    ant: Ant,
    bee: Bee,
    grasshopper: Grasshopper,

    // 'inline else' のおかげで、この print() をインターフェース
    // メソッドのように考えることができます。このユニオンの print() メソッドを
    // 持つメンバーはすべて、他の詳細を知らなくても外部コードから
    // 統一的に扱えます。素晴らしい！
    pub fn print(self: Insect) void {
        switch (self) {
            inline else => |case| return case.print(),
        }
    }
};

pub fn main() !void {
    const my_insects = [_]Insect{
        Insect{ .ant = Ant{ .still_alive = true } },
        Insect{ .bee = Bee{ .flowers_visited = 17 } },
        Insect{ .grasshopper = Grasshopper{ .distance_hopped = 32 } },
    };

    std.debug.print("=== Doctor Zoraptera's Insect Report ===\n", .{});
    for (my_insects) |insect| {
        // もう少しで完成！ここで単一のメソッド呼び出しで
        // 各昆虫を print() したいです。
        ???
    }
}

// 上記の Insect ユニオンの print() メソッドは、
// オブジェクト指向の抽象データ型の概念に非常に近いものを
// 示しています。つまり、Insect 型は基礎となるデータを含まず、
// print() 関数は実際には出力を行いません。
//
// インターフェースの目的は汎用プログラミングをサポートすることです：
// 異なるものを同じように扱い、雑然さと概念的な複雑さを
// 減らす能力です。
//
// 昆虫の日次レポートは、レポートの中の*どの*昆虫かを
// 心配する必要はありません - インターフェースを介して
// すべて同じ方法で出力されます！
//
// Zoraptera 博士もお気に入りです。
