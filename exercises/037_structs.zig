//
// 値をグループ化できることは単に便利なだけではありません。値を格納したり、
// 関数に渡したりする際に、単一のアイテムとして扱えるようにもなります。
//
// これを：
//
//     point1_x = 3;
//     point1_y = 16;
//     point1_z = 27;
//     point2_x = 7;
//     point2_y = 13;
//     point2_z = 34;
//
// こうできます：
//
//     point1 = Point{ .x=3, .y=16, .z=27 };
//     point2 = Point{ .x=7, .y=13, .z=34 };
//
// 上のPointは"struct"（"structure"の略）の例です。
// このstruct型は次のように定義できます：
//
//     const Point = struct{ x: u32, y: u32, z: u32 };
//
// structを使って楽しいものを格納しましょう：ロールプレイングのキャラクターです！
//
const std = @import("std");

// キャラクターの役割を指定するためにenumを使います。
const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

// このstructに"health"という新しいプロパティを追加して、
// u8整数型にしてください。
const Character = struct {
    role: Role,
    gold: u32,
    experience: u32,
    health: u8,
};

pub fn main() void {
    // Glorpをhealthが100の状態で初期化してください。
    var glorp_the_wise = Character{
        .role = Role.wizard,
        .gold = 20,
        .experience = 10,
        .health = 100,
    };

    // Glorpは金を手に入れました。
    glorp_the_wise.gold += 5;

    // 痛い！Glorpがパンチを食らいました！
    glorp_the_wise.health -= 10;

    std.debug.print("Your wizard has {} health and {} gold.\n", .{
        glorp_the_wise.health,
        glorp_the_wise.gold,
    });
}
