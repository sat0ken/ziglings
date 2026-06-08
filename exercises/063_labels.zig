//
// ループの本体はブロックであり、ブロックは式でもあります。
// 値を評価して返すためにどのように使われるかを見てきました。
// この概念をさらに展開すると、'ラベル'を適用することで
// ブロックに名前を付けることもできます：
//
//     my_label: { ... }
//
// ブロックにラベルを付けると、'break'を使って
// そのブロックから抜け出すことができます。
//
//     outer_block: {           // 外側のブロック
//         while (true) {       // 内側のブロック
//             break :outer_block;
//         }
//         unreachable;
//     }
//
// 先ほど学んだように、break文を使って値を返すことができます。
// つまり、ラベル付きブロックからも値を返せるのでしょうか？
// はい、そうです！
//
//     const foo = make_five: {
//         const five = 1 + 1 + 1 + 1 + 1;
//         break :make_five five;
//     };
//
// ラベルはループにも使えます。特定のレベルのネストされた
// ループから抜け出せることは、毎日使うわけではありませんが、
// いざという時に非常に便利です。内側のループから値を返せることは
// 時にとても便利で、ズルをしているような感覚すらあります
// （多くの一時変数を作らずに済みます）。
//
//     const bar: u8 = two_loop: while (true) {
//         while (true) {
//             break :two_loop 2;
//         }
//     } else 0;
//
// 上の例では、breakは"two_loop"とラベル付けされた外側のループから
// 抜け出し、値2を返します。else節は外側のtwo_loopに付随しており、
// breakが呼ばれずにループが終了した場合に評価されます。
//
// 最後に、'continue'文でもブロックラベルを使えます：
//
//     my_while: while (true) {
//         continue :my_while;
//     }
//
const print = @import("std").debug.print;

// 前述の通り、これら2つの数値に明示的な型が
// 不要な理由がすぐに分かります。もう少し待ってください！
const ingredients = 4;
const foods = 4;

const Food = struct {
    name: []const u8,
    requires: [ingredients]bool,
};

//                 Chili  Macaroni  Tomato Sauce  Cheese
// ------------------------------------------------------
//  Mac & Cheese              x                     x
//  Chili Mac        x        x
//  Pasta                     x          x
//  Cheesy Chili     x                              x
// ------------------------------------------------------

const menu: [foods]Food = [_]Food{
    Food{
        .name = "Mac & Cheese",
        .requires = [ingredients]bool{ false, true, false, true },
    },
    Food{
        .name = "Chili Mac",
        .requires = [ingredients]bool{ true, true, false, false },
    },
    Food{
        .name = "Pasta",
        .requires = [ingredients]bool{ false, true, true, false },
    },
    Food{
        .name = "Cheesy Chili",
        .requires = [ingredients]bool{ true, false, false, true },
    },
};

pub fn main() void {
    // Cafeteria USAへようこそ！好きな食材を選べば、
    // 美味しい食事を提供します。
    //
    // カフェテリアのお客様へのご注意：すべての食材の組み合わせで
    // 食事が作れるわけではありません。デフォルトの食事はマカロニと
    // チーズです。
    //
    // ソフトウェア開発者へのご注意：この小さな例では食材番号を
    // ハードコーディングしても問題ありませんが（配列の位置に基づく）、
    // 実際のアプリケーションでは完全にNGです！
    const wanted_ingredients = [_]u8{ 0, 3 }; // チリ、チーズ

    // メニューの各Foodを見ていきます...
    const meal = food_loop: for (menu) |food| {

        // そのFoodに必要な各食材を見ていきます...
        for (food.requires, 0..) |required, required_ingredient| {

            // この食材は必要ないのでスキップします。
            if (!required) continue;

            // お客様がこの食材を望んでいるか確認します。
            // （want_itは各食品の必要食材リストにおける
            // 食材のインデックス番号になることを覚えておいてください。）
            const found = for (wanted_ingredients) |want_it| {
                if (required_ingredient == want_it) break true;
            } else false;

            // この必要な食材が見つからなかったので、
            // このFoodは作れません。外側のループを続けます。
            if (!found) continue :food_loop;
        }

        // ここまで来たということは、このFoodに必要な
        // 食材がすべて望まれていたということです。
        //
        // このFoodをループから返してください。
        break;
    };
    // ^ おっと！要求された食材が見つからない場合の
    // デフォルトのFoodとしてMac & Cheeseを返すのを忘れました。

    print("Enjoy your {s}!\n", .{meal.name});
}

// チャレンジ：内側のループの'found'変数をなくすこともできます。
// どうすればいいか考えてみましょう！
