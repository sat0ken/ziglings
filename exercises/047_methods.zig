//
// 助けてください！邪悪なエイリアンが地球中に卵を隠していて、
// 孵化し始めました！
//
// 戦いに挑む前に、3 つのことを知っておく必要があります：
//
// 1. 構造体（およびその他の「型定義」）に関数を付けることができます：
//
//     const Foo = struct{
//         pub fn hello() void {
//             std.debug.print("Foo says hello!\n", .{});
//         }
//     };
//
// 2. 構造体のメンバー関数は、その構造体内で「名前空間化」されており、
//    「名前空間」を指定してから「ドット構文」を使って呼び出します：
//
//     Foo.hello();
//
// 3. これらの関数の「優れた」機能は、最初の引数が構造体のインスタンス
//    （またはそのポインタ）の場合、型の代わりにインスタンスを名前空間として
//    使用できることです：
//
//     const Bar = struct{
//         pub fn a(self: Bar) void {}
//         pub fn b(this: *Bar, other: u8) void {}
//         pub fn c(bar: *const Bar) void {}
//     };
//
//    var bar = Bar{};
//    bar.a() // Bar.a(bar) と同等
//    bar.b(3) // Bar.b(&bar, 3) と同等
//    bar.c() // Bar.c(&bar) と同等
//
//    パラメータの名前は何でも構いません。self を使う人もいれば、
//    型名の小文字版を使う人もいますが、最も適切なものを自由に使ってください。
//
// さあ、準備完了です。
//
// では、エイリアン構造体がすべて消えるまでやっつけてください。
// さもないと地球は滅んでしまいます！
//
const std = @import("std");

// この恐ろしい Alien 構造体を見てください。敵を知れ！
const Alien = struct {
    health: u8,

    // このメソッドは憎らしい：
    pub fn hatch(strength: u8) Alien {
        return Alien{
            .health = strength * 5,
        };
    }
};

// あなたの頼もしい武器。エイリアンをやっつけろ！
const HeatRay = struct {
    damage: u8,

    // このメソッドは好きです：
    pub fn zap(self: HeatRay, alien: *Alien) void {
        alien.health -= if (self.damage >= alien.health) alien.health else self.damage;
    }
};

pub fn main() void {
    // 様々な強さのエイリアンたちを見てください！
    var aliens = [_]Alien{
        Alien.hatch(2),
        Alien.hatch(1),
        Alien.hatch(3),
        Alien.hatch(3),
        Alien.hatch(5),
        Alien.hatch(3),
    };

    var aliens_alive = aliens.len;
    const heat_ray = HeatRay{ .damage = 7 }; // ヒートレイ兵器が与えられました。

    // すべてのエイリアンを倒したかどうか確認し続けます。
    while (aliens_alive > 0) {
        aliens_alive = 0;

        // すべてのエイリアンをポインタでループします（* はポインタキャプチャ値を作ります）
        for (&aliens) |*alien| {

            // *** ここでヒートレイでエイリアンをやっつけましょう！ ***
            heat_ray.zap(alien);

            // エイリアンの体力がまだ 0 以上なら、まだ生きています。
            if (alien.health > 0) aliens_alive += 1;
        }

        std.debug.print("{} aliens. ", .{aliens_alive});
    }

    std.debug.print("Earth is saved!\n", .{});
}
