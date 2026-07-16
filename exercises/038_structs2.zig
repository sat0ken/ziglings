//
// structに値をグループ化することは単に便利なだけではありません。
// 格納したり、関数に渡したりする際に値を単一のアイテムとして
// 扱えるようにもなります。
//
// この演習では、structを配列に格納する方法と、
// ループを使ってそれらを出力する方法を示します。
//
const std = @import("std");

const Role = enum {
    wizard,
    thief,
    bard,
    warrior,
};

const Character = struct {
    role: Role,
    gold: u32,
    health: u8,
    experience: u32,
};

pub fn main() void {
    var chars: [2]Character = undefined;

    // Glorp the Wise
    chars[0] = Character{
        .role = Role.wizard,
        .gold = 20,
        .health = 100,
        .experience = 10,
    };

    chars[1] = Character{
        .role = Role.bard,
        .gold = 10,
        .health = 100,
        .experience = 20,
    };

    // "Zump the Loud"を次のプロパティで追加してください：
    //
    //     role       bard
    //     gold       10
    //     health     100
    //     experience 20
    //
    // Zumpを追加せずにこのプログラムを実行してみてください。
    // どうなりますか？なぜですか？

    // RPGキャラクターを全てループで出力：
    for (chars, 0..) |c, num| {
        std.debug.print("Character {} - G:{} H:{} XP:{}\n", .{
            num + 1, c.gold, c.health, c.experience,
        });
    }
}

// 上記のようにZumpを追加せずにプログラムを実行してみると、
// 「ゴミ」のような値が表示されます。デバッグモード
//（デフォルト）では、Zigは全ての未定義の場所に2進数の繰り返しパターン
// "10101010"（16進数で0xAA）を書き込んで、デバッグ時に
// 見つけやすくします。
