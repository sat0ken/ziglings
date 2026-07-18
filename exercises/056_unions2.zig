//
// ユニオンのアクティブフィールドを手動で管理するのは
// 本当に不便ですよね？
//
// ありがたいことに、Zig には「タグ付きユニオン」もあります。
// タグ付きユニオンを使うと、どのフィールドがアクティブかを表す
// enum 値をユニオン内に保存できます。
//
//     const FooTag = enum{ small, medium, large };
//
//     const Foo = union(FooTag) {
//         small: u8,
//         medium: u32,
//         large: u64,
//     };
//
// これでアクティブなフィールドに対して直接 switch を使えます：
//
//     var f = Foo{ .small = 10 };
//
//     switch (f) {
//         .small => |my_small| do_something(my_small),
//         .medium => |my_medium| do_something(my_medium),
//         .large => |my_large| do_something(my_large),
//     }
//
// Insect にタグ付きユニオンを使いましょう
//（Zoraptera 博士も賛成しています）。
//
const std = @import("std");

const InsectStat = enum { flowers_visited, still_alive };

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};

pub fn main() void {
    const ant = Insect{ .still_alive = true };
    const bee = Insect{ .flowers_visited = 16 };

    std.debug.print("Insect report! ", .{});

    // ユニオンをそのまま渡すだけで本当に大丈夫なのでしょうか？
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

// ところで、ユニオンは optional 値やエラーを思い出させましたか？
// Optional 値は基本的に「null ユニオン」であり、エラーは「エラーユニオン型」を
// 使用します。これで私たちのユニオンも追加して、遭遇する可能性のある
// あらゆる状況に対処できます：
//          union(Tag) { value: u32, toxic_ooze: void }
