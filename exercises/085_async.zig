//
// 以前のバージョンの Zig では、async/await はスタックフレームを直接
// 操作する 'suspend'、'resume'、'async' などの特別なキーワードを
// 使用していました。それらのキーワードはもう存在しません！
//
// Zig 0.16 では、それらを統一された I/O インターフェース std.Io に
// 置き換えました。このインターフェースは VTable パターン（関数ポインタの構造体）を
// 使用して、異なる並行処理バックエンドを抽象化します：
//
//   * Threaded  - スレッドプールベースの I/O
//   * Evented   - OS に最適なイベントループバックエンドを選択：
//       * Uring    Linux 上（io_uring）
//       * Kqueue   BSD/macOS 上
//       * Dispatch macOS 上（Grand Central Dispatch）
//
// Io 構造体自体は小さいです：
//
//     const Io = struct {
//         userdata: ?*anyopaque,   // バックエンドの不透明な状態
//         vtable: *const VTable,   // 関数ポインタのテーブル
//     };
//
// コードは Io 値を受け取り、そのメソッドを呼び出します。
// バックエンドは初期化時に選択されます - コードはどれかを
// 知る必要はありません！
//
// Zig 0.16 では、main() は I/O と並行処理サポートを
// オプトインするために std.process.Init 構造体を受け取ります：
//
//     pub fn main(init: std.process.Init) !void {
//         const io = init.io;
//         // ... io を使う ...
//     }
//
// シンプルに始めましょう。init から Io インターフェースを取り出し、
// それを使って現在時刻を取得するように main 関数を修正してください。
//
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.???;

    // Io インターフェースを使って現在のウォールクロック時刻を取得します。
    // ヒント：Timestamp.now() は Io と Clock 型（.real = ウォールクロック）を受け取ります。
    const timestamp = std.Io.Timestamp.now(io, .real);

    // Unix エポックからの秒数でタイムスタンプを出力します。
    std.debug.print("Current time: {}s since epoch\n", .{timestamp.toSeconds()});
}
