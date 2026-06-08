//
// 前提条件：
//    - exercise/109_files.zig を実行済み、または
//    - {project_root}/output/zigling.txt というファイルを
//      内容 `It's zigling time!`（合計18バイト）で作成済み
//
// ファイルに書き込んでも読み込まなければ意味がありませんよね？
// 先ほど作成したファイルの内容を読み込むプログラムを書きましょう。
//
// 適切なファイルが作成済みであることを前提としています。
//
// では、ゲームプランを説明します。
//    - まず、{project_root}/output/ ディレクトリを開きます
//    - 次に、そのディレクトリの `zigling.txt` ファイルを開きます
//    - そして、すべての文字を'A'で初期化した文字配列を作成して出力します
//    - その後、ファイルの内容を配列に読み込みます
//    - 最後に、読み込んだ内容を出力します
//
// 注意：簡単のため、バッファリングなしでバイト単位で読み込みます。
// 実際のアプリケーションでは、パフォーマンス向上のために
// 通常バッファを使用します。バッファリングI/Oについては後のエクササイズで学びます。

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // 現在の作業ディレクトリを取得します
    const cwd = std.Io.Dir.cwd();

    // 109_filesエクササイズを完了済みであれば ./output を開こうとします
    var output_dir = try cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // ファイルを開こうとします
    const file = try output_dir.openFile(io, "zigling.txt", .{});
    defer file.close(io);

    // 文字'A'ですべてを初期化したu8の配列を作成します
    // 配列のサイズを決める必要があります。64が良い数字に思えます
    // 配列の繰り返し関数を覚えていますか？
    var content: ??? = ???('A');
    // これは出力されるはずです：`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`
    std.debug.print("{s}\n", .{content});

    var file_reader = file.reader(io, &.{});
    const reader = &file_reader.interface;

    // 暴力的な脅しはこの場合答えではないようです
    // ファイルの内容を読み込む方法をここで探してみてください
    // https://ziglang.org/documentation/master/std/#std.Io.Reader
    // ヒント：スライスに読み込むメソッドを探してください
    const bytes_read = zig_read_the_file_or_i_will_fight_you(&content);

    // うわ、少し叫びすぎです。zigling timeに興奮しているのはわかりますが、少し落ち着いてください。
    // ファイルから読み込んだものだけを出力できますか？
    std.debug.print("Successfully Read {d} bytes: {s}\n", .{
        bytes_read,
        content, // この行のみ変更してください
    });
}
