//
// エクササイズ011、012、013、014でwhileループを学びました。
// エクササイズ030と031でswitch式も学びました。
// エクササイズ063でラベルの使い方も見ました。
//
// whileループとswitch文をcontinueおよびbreak文と組み合わせることで、
// 非常に簡潔なステートマシンを作成できます。
//
// その例として：
//
//      pub fn main() void {
//          var op: u8 = 1;
//          while (true) {
//              switch (op) {
//                  1 => { op = 2; continue; },
//                  2 => { op = 3; continue; },
//                  3 => return,
//                  else => {},
//              }
//              break;
//          }
//          std.debug.print("This statement cannot be reached\n", .{});
//      }
//
// これまでに学んだことをすべて組み合わせることで、ラベル付きswitchに進めます。
//
// ラベル付きswitchは追加の糖衣構文で、あらゆる種類の
// お菓子（パフォーマンス上のメリット）が付いています。
// 信じられませんか？直接ソースへ https://github.com/ziglang/zig/pull/21367
//
// 上記の抜粋をラベル付きswitchで実装すると：
//
//      pub fn main() void {
//          foo: switch (@as(u8, 1)) {
//              1 => continue :foo 2,
//              2 => continue :foo 3,
//              3 => return,
//              else => {},
//          }
//          std.debug.print("This statement cannot be reached\n", .{});
//      }
//
// この2番目のケースの実行フローは：
//  1. switchは値'1'で開始します；
//  2. switchはケース'1'を評価し、continue文を使って
//     ラベル付きswitchを再評価します。今度は値'2'を提供します；
//  3. ケース'2'でケース'1'と同じパターンを繰り返しますが、
//     評価される値は'3'になります；
//  4. 最後にケース'3'に到達し、関数全体からreturnします。
//     そのためdebug文は実行されません。
//  5. この例では、入力に明確で網羅的なパターンがなく、
//     本質的に任意の'u8'整数になり得るため、
//     明示的にカバーされていないすべてのケースを
//     'else => {}'ブランチをデフォルトケースとして処理する必要があります。
//
//
const std = @import("std");

const PullRequestState = enum(u8) {
    Draft,
    InReview,
    Approved,
    Rejected,
    Merged,
};

pub fn main() void {
    // プルリクエストが拒否され続けています。
    // どうやって修正しますか？
    pr: switch (PullRequestState.Draft) {
        PullRequestState.Draft => continue :pr PullRequestState.InReview,
        PullRequestState.InReview => continue :pr PullRequestState.Rejected,
        PullRequestState.Approved => continue :pr PullRequestState.Merged,
        PullRequestState.Rejected => {
            std.debug.print("The pull request has been rejected.\n", .{});
            return;
        },
        PullRequestState.Merged => break, // どこにbreakすべきかわかりますか？
    }
    std.debug.print("The pull request has been merged.\n", .{});
}
