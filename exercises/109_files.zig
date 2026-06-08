//
// これまでは、エイリアンとの戦いや隠者の帳簿管理には十分な
// コンソール出力だけを行ってきました。
//
// しかし、他の多くのタスクではファイルシステムとのやり取りが必要です。
// ファイルシステムはコンピュータ上のファイルを整理するための
// 基盤となる構造です。
//
// ファイルシステムはファイルをディレクトリに整理することで
// 階層的な構造を提供します。ディレクトリはファイルと他のディレクトリを保持し、
// ナビゲート可能なツリー構造を作成します。
//
// 幸いなことに、Zig標準ライブラリはファイルシステムと
// やり取りするためのシンプルなAPIを提供しています。
// 詳細なドキュメントはこちら：
//
// https://ziglang.org/documentation/master/std/#std.Io
//
// このエクササイズでは以下を試みます：
//   - 新しいディレクトリを作成する、
//   - そのディレクトリにファイルを開く、
//   - ファイルに書き込む。
//
// 注意：簡単のため、バッファリングなしでバイト単位で書き込みます。
// 実際のアプリケーションでは、パフォーマンス向上のために
// 通常バッファを使用します。バッファリングI/Oについては後のエクササイズで学びます。
//
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // デフォルトのI/O実装
    const io = init.io;

    // まず現在の作業ディレクトリを取得します
    const cwd: std.Io.Dir = std.Io.Dir.cwd();

    // 次に出力ファイルを保存するための新しいディレクトリ /output/ の
    // 作成を試みます。
    cwd.createDir(io, "output", .default_dir) catch |e| switch (e) {
        // このプログラムを複数回実行したい場合があり、
        // パスがすでに作成されている可能性があります。
        // そのため何もしないでこのエラーを処理する必要があります。
        //
        // error.PathAlreadyExists をキャッチして何もしないようにしたいです
        ??? => {},
        // 予期しない他のエラーはそのまま伝播します
        else => return e,
    };

    // 次に新しく作成したディレクトリを開こうとします
    // ちょっと待ってください...
    // ディレクトリを開くのは失敗するかもしれません！
    // どうすればよいでしょうか？
    var output_dir: std.Io.Dir = try cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // ファイル `zigling.txt` を開こうとします。
    // エラーは上に伝播します
    const file: std.Io.File = try output_dir.createFile(io, "zigling.txt", .{});
    // ファイルの使用が終わったらクローズするのは良い習慣です。
    // 他のプログラムが読めるようになり、データの破損を防ぎます。
    // しかし、ここではまだファイルへの書き込みが終わっていません。
    // もしZigにスコープの終わりまでコードの実行を「遅延」させる
    // キーワードがあればいいのですが...
    file.close(io);

    // これらの行をファイルクローズ行より上に移動させてはいけません！
    var file_writer = file.writer(io, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write("It's zigling time!");
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}
// ファイルに実際に書き込まれているか確認するには、以下のいずれかを行います：
// 1. テキストエディタでファイルを開く、または
// 2. 次のコマンドのいずれかでコンソールにファイルの内容を出力する
//    Linux/macOS:   >> cat ./output/zigling.txt
//    Windows (CMD): >> type .\output\zigling.txt
//
//
// ファイル作成についての詳細
//
// 注目：
// ... try output_dir.createFile(io, "zigling.txt", .{});
//                                                  ^^^
//                 この匿名structを関数呼び出しに渡しています
//
// これはデフォルトフィールドを持つstruct `CreateFlag` です：
// {
//      read: bool = false,
//      truncate: bool = true,
//      exclusive: bool = false,
//      lock: Lock = .none,
//      lock_nonblocking: bool = false,
//      mode: Mode = default_mode
// }
//
// 質問：
//   - ファイルを開いた後に読み取りもしたい場合はどうすればよいでしょうか？
//   - こちらのstruct `std.Io.Dir` のドキュメントを参照してください：
//     https://ziglang.org/documentation/master/std/#std.Io.Dir
//       - ファイルを開く関数はありますか？ファイルを削除する関数は？
//       - それらの関数にはどのようなオプションが使えますか？
