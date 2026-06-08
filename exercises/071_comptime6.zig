//
// プログラムでループを使いたい場面が何度かありましたが、
// コンパイル時にしかできないことをしようとしていたため
// 使えませんでした。結局、普通の人のようにそれらを手動で
// やらなければなりませんでした。バカにするな！私たちは
// プログラマーです！コンピューターがこの作業をすべきです。
//
// 'inline for' はコンパイル時に実行され、上記のような状況で
// 通常の実行時の 'for' ループが許可されない場合に、
// アイテムのシリーズをプログラム的にループすることを
// 可能にします：
//
//     inline for (.{ u8, u16, u32, u64 }) |T| {
//         print("{} ", .{@typeInfo(T).int.bits});
//     }
//
// 上の例では、コンパイル時にのみ利用可能な型のリストを
// ループしています。
//
const print = @import("std").debug.print;

// 演習065でイントロスペクションのための組み込み関数を
// 使ったNarcissusを覚えていますか？彼が戻ってきました。
const Narcissus = struct {
    me: *Narcissus = undefined,
    myself: *Narcissus = undefined,
    echo: void = undefined,
};

pub fn main() void {
    print("Narcissus has room in his heart for:", .{});

    // 前回 Narcissus 構造体を調べたとき、3つのフィールドそれぞれに
    // 手動でアクセスしなければなりませんでした。'if' 文が
    // ほぼ逐語的に3回繰り返されていました。最悪！
    //
    // 対応するスライス（同じ長さです）の各フィールドに対して
    // 以下のブロックを実装するために 'inline for' を使ってください！

    const field_names = @typeInfo(Narcissus).@"struct".field_names;
    const field_types = @typeInfo(Narcissus).@"struct".field_types;

    ??? {
        if (field_type != void) {
            print(" {s}", .{field_name});
        }
    }

    // できたら、演習065に戻って、書いたものと
    // あそこにあった怪物を比較してみてください！

    print(".\n", .{});
}
