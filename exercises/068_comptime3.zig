//
// 関数パラメータの前に 'comptime' を置くことで、
// その関数に渡される引数がコンパイル時に既知でなければ
// ならないことを強制できます。実はずっとこのような関数を
// 使っていました。std.debug.print() がそうです：
//
//     fn print(comptime fmt: []const u8, args: anytype) void
//
// フォーマット文字列パラメータ 'fmt' が 'comptime' と
// マークされていることに注意してください。これの便利な点の
// 1つは、フォーマット文字列のエラーを実行時クラッシュではなく
// コンパイル時に確認できることです。
//
// （実際のフォーマット処理は std.Io.Writer.print() によって行われ、
// 完全なフォーマット文字列パーサーを含みます。これはすべて
// コンパイル時に実行されます！）
//
const print = @import("std").debug.print;

// この構造体はモデルボートのモデルです。好きなスケールに
// 変換できます：1:2 は半分のサイズ、1:32 は実物の32分の1、
// などです。
const Schooner = struct {
    name: []const u8,
    scale: u32 = 1,
    hull_length: u32 = 143,
    bowsprit_length: u32 = 34,
    mainmast_height: u32 = 95,

    fn scaleMe(self: *Schooner, comptime scale: u32) void {
        comptime var my_scale = scale;

        // ここでは気の利いたことをしています：誤って
        // 1:0 のスケールを作ろうとする可能性を予測しています。
        // 実行時にゼロ除算エラーになる代わりに、
        // コンパイルエラーにしています。
        //
        // これはほとんどの場合において正しい解決策でしょう。
        // しかし、私たちのモデルボートモデルプログラムは
        // とてもカジュアルで、「意図した通りに動く」ことを
        // 望んでいます。
        //
        // スケール0を1に設定するように変更してください。
        if (my_scale == 0) @compileError("Scale 1:0 is not valid!");

        self.scale = my_scale;
        self.hull_length /= my_scale;
        self.bowsprit_length /= my_scale;
        self.mainmast_height /= my_scale;
    }

    fn printMe(self: Schooner) void {
        print("{s} (1:{}, {} x {})\n", .{
            self.name,
            self.scale,
            self.hull_length,
            self.mainmast_height,
        });
    }
};

pub fn main() void {
    var whale = Schooner{ .name = "Whale" };
    var shark = Schooner{ .name = "Shark" };
    var minnow = Schooner{ .name = "Minnow" };

    // ちょっと待ってください。このランタイム変数を
    // scaleMe() メソッドの引数として渡すことはできません。
    // それを可能にするには何が必要でしょうか？
    var scale: u32 = undefined;

    scale = 32; // 1:32 スケール

    minnow.scaleMe(scale);
    minnow.printMe();

    scale -= 16; // 1:16 スケール

    shark.scaleMe(scale);
    shark.printMe();

    scale -= 16; // 1:0 スケール（おっと、でもこれは修正しないでください！）

    whale.scaleMe(scale);
    whale.printMe();
}
//
// 深掘り：
//
// 1:0 のスケールでモデルを作ろうとするとどうなるでしょうか？
//
//    A) すでに完成しています！
//    B) 精神的なゼロ除算エラーに苦しみます。
//    C) 特異点を構築して地球を破壊します。
//
// 0:1 のスケールのモデルはどうでしょう？
//
//    A) すでに完成しています！
//    B) 何もないものを元の何もないものの無限大の形に
//       丁寧に配置します。
//    C) 特異点を構築して地球を破壊します。
//
// 答えはZiglingsパッケージの裏面にあります。
