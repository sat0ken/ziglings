//
// 変数が値を保持するかもしれないし、保持しないかもしれない場合があります。
// Zig にはこのアイデアを表現する洗練された方法として「Optional（省略可能型）」があります。
// Optional 型は次のように '?' を付けるだけです：
//
//     var foo: ?u32 = 10;
//
// これで foo は u32 整数 OR null（値が「存在しない」という宇宙的恐怖の値）を保持できます！
//
//     foo = null;
//
//     if (foo == null) beginScreaming();
//
// Optional の値を null でない型（この場合は u32 整数）として使用する前に、
// null でないことを保証する必要があります。その方法の一つは
// "orelse" 文で「脅す」ことです。
//
//     var bar = foo orelse 2;
//
// ここで bar は foo に格納された u32 整数値か、
// foo が null の場合は 2 になります。
//
const std = @import("std");

pub fn main() void {
    const result = deepThought();

    // result を「脅して」、answer が deepThought() からの整数値か
    // 数値 42 になるようにしてください：
    const answer: u8 = result orelse 42;

    std.debug.print("The Ultimate Answer: {}.\n", .{answer});
}

fn deepThought() ?u8 {
    // Deep Thought の出力品質が低下しているようです。
    // でもそのままにしておきます。ごめんなさい、Deep Thought。
    return null;
}
// 過去のおさらい：
//
// Optional はエラーユニオン型によく似ています。エラーユニオン型は
// 値かエラーのどちらかを保持できます。同様に、orelse 文は
// 値を「アンラップ」するか、デフォルト値を提供する catch 文に似ています：
//
//    var maybe_bad: Error!u32 = Error.Evil;
//    var number: u32 = maybe_bad catch 0;
//
