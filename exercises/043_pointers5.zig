//
// 整数と同様に、構造体を変更したい場合は構造体へのポインタを渡すことができます。
// ポインタは構造体への参照（「リンク」）を保持する必要があるときにも役立ちます。
//
//     const Vertex = struct{ x: u32, y: u32, z: u32 };
//
//     var v1 = Vertex{ .x=3, .y=2, .z=5 };
//
//     var pv: *Vertex = &v1;   // <-- 構造体へのポインタ
//
// "pv" ポインタを逆参照しなくても構造体のフィールドにアクセスできることに注意してください：
//
//     OK:  pv.x
//     NG:  pv.*.x
//
// 構造体へのポインタを引数として受け取る関数を書くことができます。
// この foo() 関数は構造体 v を変更します：
//
//     fn foo(v: *Vertex) void {
//         v.x += 2;
//         v.y += 3;
//         v.z += 7;
//     }
//
// そして次のように呼び出します：
//
//     foo(&v1);
//
// RPG の例に戻って、Character を参照で受け取り表示する printCharacter() 関数を
// 作りましょう。さらに、リンクされた "mentor" の Character がある場合はそれも表示します。
//
const std = @import("std");

const Class = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    class: Class,
    gold: u32,
    health: u8 = 100, // デフォルト値を指定できます
    experience: u32,

    // null 値を許可するために '?' を使用する必要があります。
    // ただし、これについては後で説明します。誰にも言わないでください。
    mentor: ?*Character = null,
};

pub fn main() void {
    var mighty_krodor = Character{
        .class = Class.wizard,
        .gold = 10000,
        .experience = 2340,
    };

    var glorp = Character{ // Glorp！
        .class = Class.wizard,
        .gold = 10,
        .experience = 20,
        .mentor = &mighty_krodor, // Glorp のメンターは Mighty Krodor
    };

    // 修正してください！
    // Glorp を printCharacter() に渡してください：
    printCharacter(&glorp);
}

// この関数のパラメータ "c" は Character 構造体へのポインタです。
fn printCharacter(c: *Character) void {
    // 以前に見たことのない書き方です：enum で switch するとき、
    // 完全な enum 名を書く必要はありません。Zig は Class の enum 値で
    // switch するときに ".wizard" が "Class.wizard" を意味すると理解しています：
    const class_name = switch (c.class) {
        .wizard => "Wizard",
        .thief => "Thief",
        .bard => "Bard",
        .warrior => "Warrior",
    };

    std.debug.print("{s} (G:{} H:{} XP:{})\n", .{
        class_name,
        c.gold,
        c.health,
        c.experience,
    });

    // "optional" 値を確認してキャプチャする方法については
    // 後で説明します（上記の '?' と対になります）。
    if (c.mentor) |mentor| {
        std.debug.print("  Mentor: ", .{});
        printCharacter(mentor);
    }
}
