//
// Zig で使用できる型のバリエーションについて多くの情報を吸収してきました。
// おおまかに順番に並べると：
//
//                          u8  単一アイテム
//                         *u8  単一アイテムポインタ
//                        []u8  スライス（実行時にサイズが判明）
//                       [5]u8  5 つの u8 の配列
//                       [*]u8  多要素ポインタ（0 個以上）
//                 enum {a, b}  一意な値 a と b の集合
//                error {e, f}  一意なエラー値 e と f の集合
//      struct {y: u8, z: i32}  値 y と z のグループ
// union(enum) {a: u8, b: i32}  u8 か i32 のどちらかの単一値
//
// 上記のいずれかの型の値は "var" または "const" として代入でき、
// 代入された名前からの変更（可変性）を許可または禁止できます：
//
//     const a: u8 = 5; // 不変
//       var b: u8 = 5; // 可変
//
// 上記のいずれかからエラーユニオンや optional 型を作ることもできます：
//
//     var a: E!u8 = 5; // u8 か集合 E のエラーのどちらか
//     var b: ?u8 = 5;  // u8 か null のどちらか
//
// これを踏まえて、近所の隠者を助けられるかもしれません。彼は
// 森の中の旅を計画するための小さな Zig プログラムを作りましたが、
// いくつか間違いがあります。
//
// *************************************************************
// *               この演習に関する注意事項                    *
// *                                                           *
// * このプログラムのすべてを読んで理解する必要はありません。  *
// * これは非常に大きな例です。さっと読み流してから、          *
// * 実際に壊れている少数の部分だけに集中してください！        *
// *                                                           *
// *************************************************************
//
const print = @import("std").debug.print;

// grue は Zork へのオマージュです。
const TripError = error{ Unreachable, EatenByAGrue };

// まずは地図上の場所から。それぞれに名前と
// 移動の距離や難易度（隠者の判断による）があります。
//
// 場所は可変（var）として宣言していることに注意してください。後でパスを
// 代入する必要があるためです。なぜかというと、パスは場所へのポインタを含んでおり、
// 今すぐ代入すると依存ループが生じてしまうためです！
const Place = struct {
    name: []const u8,
    paths: []const Path = undefined,
};

var a = Place{ .name = "Archer's Point" };
var b = Place{ .name = "Bridge" };
var c = Place{ .name = "Cottage" };
var d = Place{ .name = "Dogwood Grove" };
var e = Place{ .name = "East Pond" };
var f = Place{ .name = "Fox Pond" };

//           隠者の手書き ASCII 地図
//  +---------------------------------------------------+
//  |         * Archer's Point                ~~~~      |
//  | ~~~                              ~~~~~~~~         |
//  |   ~~~| |~~~~~~~~~~~~      ~~~~~~~                 |
//  |         Bridge     ~~~~~~~~                       |
//  |  ^             ^                           ^      |
//  |     ^ ^                      / \                  |
//  |    ^     ^  ^       ^        |_| Cottage          |
//  |   Dogwood Grove                                   |
//  |                  ^     <boat>                     |
//  |  ^  ^  ^  ^          ~~~~~~~~~~~~~    ^   ^       |
//  |      ^             ~~ East Pond ~~~               |
//  |    ^    ^   ^       ~~~~~~~~~~~~~~                |
//  |                           ~~          ^           |
//  |           ^            ~~~ <-- short waterfall    |
//  |   ^                 ~~~~~                         |
//  |            ~~~~~~~~~~~~~~~~~                      |
//  |          ~~~~ Fox Pond ~~~~~~~    ^         ^     |
//  |      ^     ~~~~~~~~~~~~~~~           ^ ^          |
//  |                ~~~~~                              |
//  +---------------------------------------------------+
//
// 地図上の場所の数に基づいてプログラムのメモリを予約します。
// コンパイルされると実際にはプログラムで使用しないため、
// この値の型を指定する必要はありません！（まだ意味がわからなくても大丈夫です。）
const place_count = 6;

// では、場所間のすべてのパスを作成しましょう。パスは一つの場所から
// 別の場所へ行き、距離を持ちます。
const Path = struct {
    from: *const Place,
    to: *const Place,
    dist: u8,
};

// ところで、以下のコードが大量の退屈な手作業のように見えるなら、
// その通りです！Zig のキラー機能の一つは、コンパイル時に実行されるコードを
// 書いて繰り返しのコードを「自動化」できることです（他の言語のマクロに似ています）。
// でもそのやり方はまだ学んでいません！
const a_paths = [_]Path{
    Path{
        .from = &a, // from: Archer's Point
        .to = &b, //   to: Bridge
        .dist = 2,
    },
};

const b_paths = [_]Path{
    Path{
        .from = &b, // from: Bridge
        .to = &a, //   to: Archer's Point
        .dist = 2,
    },
    Path{
        .from = &b, // from: Bridge
        .to = &d, //   to: Dogwood Grove
        .dist = 1,
    },
};

const c_paths = [_]Path{
    Path{
        .from = &c, // from: Cottage
        .to = &d, //   to: Dogwood Grove
        .dist = 3,
    },
    Path{
        .from = &c, // from: Cottage
        .to = &e, //   to: East Pond
        .dist = 2,
    },
};

const d_paths = [_]Path{
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &b, //   to: Bridge
        .dist = 1,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &c, //   to: Cottage
        .dist = 3,
    },
    Path{
        .from = &d, // from: Dogwood Grove
        .to = &f, //   to: Fox Pond
        .dist = 7,
    },
};

const e_paths = [_]Path{
    Path{
        .from = &e, // from: East Pond
        .to = &c, //   to: Cottage
        .dist = 2,
    },
    Path{
        .from = &e, // from: East Pond
        .to = &f, //   to: Fox Pond
        .dist = 1, // （小さな滝を一方向に下る！）
    },
};

const f_paths = [_]Path{
    Path{
        .from = &f, // from: Fox Pond
        .to = &d, //   to: Dogwood Grove
        .dist = 7,
    },
};

// 森の中の最適なルートを計画したら、それを「旅」にします。
// 旅は場所とパスが交互に続く系列です。
// 場所とパスの両方を同じ配列に入れるために TripItem ユニオンを使います。
const TripItem = union(enum) {
    place: *const Place,
    path: *const Path,

    // 2 種類のアイテムを正しく表示するための小さなヘルパー関数です。
    fn printMe(self: TripItem) void {
        switch (self) {
            // おっと！隠者は switch 文でユニオン値をキャプチャする方法を
            // 忘れてしまいました。print 文が動作するように
            // 各値を 'p' としてキャプチャしてください！
            .place => |p|print("{s}", .{p.name}),
            .path => |p|print("--{}->", .{p.dist}),
        }
    }
};

// 隠者のノートブックはすべての魔法が起きる場所です。ノートブックの
// エントリは地図上で発見された場所で、そこに至るパスと出発点からの
// 距離を記録します。もし場所に到達するより良いパス（短い距離）が
// 見つかったら、エントリを更新します。エントリはまた「TODO リスト」
// としても機能し、次に探索するパスを追跡します。
const NotebookEntry = struct {
    place: *const Place,
    coming_from: ?*const Place,
    via_path: ?*const Path,
    dist_to_reach: u16,
};

// +------------------------------------------------+
// |           〜 隠者のノートブック 〜             |
// +---+----------------+----------------+----------+
// |   |      場所      |      出発地    |   距離   |
// +---+----------------+----------------+----------+
// | 0 | Archer's Point | null           |        0 |
// | 1 | Bridge         | Archer's Point |        2 | < next_entry
// | 2 | Dogwood Grove  | Bridge         |        1 |
// | 3 |                |                |          | < end_of_entries
// |                      ...                       |
// +---+----------------+----------------+----------+
//
const HermitsNotebook = struct {
    // 配列の繰り返し関数 @splat() を覚えていますか？一つひとつ列挙せずに
    // 配列内の複数のアイテムを代入する素晴らしい方法です。
    // ここでは null 値で配列を初期化するために使います。
    entries: [place_count]?NotebookEntry = @splat(null),

    // next_entry は「TODO リスト」のどこにいるかを追跡します。
    next_entry: u8 = 0,

    // ノートブックの空きスペースの開始位置をマークします。
    end_of_entries: u8 = 0,

    // 場所でエントリを見つけたい場合がよくあります。
    // 見つからない場合は null を返します。
    fn getEntry(self: *HermitsNotebook, place: *const Place) ?*NotebookEntry {
        for (&self.entries, 0..) |*entry, i| {
            if (i >= self.end_of_entries) break;

            // ここで隠者が行き詰まりました。NotebookEntry への
            // optional ポインタを返す必要があります。
            //
            // "entry" で持っているのはその逆：optional な
            // NotebookEntry へのポインタです！
            //
            // 一方から他方を得るには、"entry" を逆参照（.*）して
            // optional から非 null 値を取得（.?）し、そのアドレスを
            // 返す必要があります。if 文は逆参照と optional 値の
            // 「アンラップ」がどのように見えるかについてヒントを提供します。
            // "&" 演算子でアドレスを返すことを覚えておいてください。
            if (place == entry.*.?.place) return &entry.*.?;
            // 答えはこの長さにしてください：__________;
        }
        return null;
    }

    // checkNote() メソッドは魔法のノートブックの核心です。
    // NotebookEntry 構造体の形で新しいメモを受け取り、
    // そのメモの場所のエントリがすでにあるか確認します。
    //
    // ない場合は、パスと距離とともにノートブックの末尾にエントリを追加します。
    //
    // ある場合は、そのパスが以前記録したものより「良い」（短い距離）か
    // 確認します。良ければ、古いエントリを新しいもので上書きします。
    fn checkNote(self: *HermitsNotebook, note: NotebookEntry) void {
        const existing_entry = self.getEntry(note.place);

        if (existing_entry == null) {
            self.entries[self.end_of_entries] = note;
            self.end_of_entries += 1;
        } else if (note.dist_to_reach < existing_entry.?.dist_to_reach) {
            existing_entry.?.* = note;
        }
    }

    // 次の 2 つのメソッドでノートブックを「TODO リスト」として使用できます。
    fn hasNextEntry(self: *HermitsNotebook) bool {
        return self.next_entry < self.end_of_entries;
    }

    fn getNextEntry(self: *HermitsNotebook) *const NotebookEntry {
        defer self.next_entry += 1; // エントリを取得した後インクリメント
        return &self.entries[self.next_entry].?;
    }

    // 地図の探索が完了したら、すべての場所への最短パスが計算できています。
    // 出発点から目的地への完全な旅を収集するには、目的地のノートブック
    // エントリから逆方向に歩き、出発点まで coming_from ポインタをたどる
    // 必要があります。結果として、旅を逆順に並べた TripItem の配列が得られます。
    //
    // trip 配列をパラメータとして受け取るのは、main() 関数が配列のメモリを
    // 「所有」するようにしたいからです。この関数のスタックフレーム（関数の
    // 「ローカル」データ用に確保されたスペース）に配列を割り当てて
    // そのポインタやスライスを返したら、どうなると思いますか？
    //
    // 隠者はこの関数の戻り値で何かを忘れているようです。それは何でしょうか？
    fn getTripTo(self: *HermitsNotebook, trip: []?TripItem, dest: *Place) TripError!void {
        // 目的地のエントリから始めます。
        const destination_entry = self.getEntry(dest);

        // 要求された目的地に到達できなかった場合、この関数はエラーを
        // 返す必要があります（地図上ではすべての場所が他のすべての場所から
        // 到達可能なので、実際にはこれは起こり得ません）。
        if (destination_entry == null) {
            return TripError.Unreachable;
        }

        // 現在調べているエントリと、旅のアイテムを追加する場所を
        // 追跡するインデックスを保持する変数です。
        var current_entry = destination_entry.?;
        var i: u8 = 0;

        // 各ループの終わりに、continue 式がインデックスをインクリメントします。
        // なぜ 2 ずつ増やす必要があるのかわかりますか？
        while (true) : (i += 2) {
            trip[i] = TripItem{ .place = current_entry.place };

            // どこからも来ていないエントリは出発点に到達したことを意味します。
            // 完了です。
            if (current_entry.coming_from == null) break;

            // それ以外の場合、エントリにはパスがあります。
            trip[i + 1] = TripItem{ .path = current_entry.via_path.? };

            // 「来た場所」のエントリをたどります。場所で「来た場所」の
            // エントリを見つけられない場合、プログラムに何か恐ろしい
            // ことが起きています！（これは本当に起こるべきではありません。
            // グルーはいませんか？）
            // 注：ここは修正不要です。
            const previous_entry = self.getEntry(current_entry.coming_from.?);
            if (previous_entry == null) return TripError.EatenByAGrue;
            current_entry = previous_entry.?;
        }
    }
};

pub fn main() void {
    // 隠者がどこへ行きたいかを決める場所です。プログラムが動いたら、
    // 地図上の別の場所を試してみてください！
    const start = &a; // Archer's Point
    const destination = &f; // Fox Pond

    // 各 Path 配列をスライスとして各 Place に保存します。
    // 前述の通り、コンパイラが各アイテムのスペース割り当てを
    // 解決しようとするときに依存ループを作らないよう、
    // これらの参照の作成を遅らせる必要がありました。
    a.paths = a_paths[0..];
    b.paths = b_paths[0..];
    c.paths = c_paths[0..];
    d.paths = d_paths[0..];
    e.paths = e_paths[0..];
    f.paths = f_paths[0..];

    // ノートブックのインスタンスを作成し、最初の「出発点」エントリを
    // 追加します。null 値に注目してください。このエントリが
    // どのようにノートブックに追加されるかは checkNote() メソッドの
    // コメントを読んでください。
    var notebook = HermitsNotebook{};
    var working_note = NotebookEntry{
        .place = start,
        .coming_from = null,
        .via_path = null,
        .dist_to_reach = 0,
    };
    notebook.checkNote(working_note);

    // ノートブックから次のエントリを取得します（最初は今追加した
    // 「出発点」エントリです）。到達可能なすべての場所を確認するまで続けます。
    while (notebook.hasNextEntry()) {
        const place_entry = notebook.getNextEntry();

        // 現在の場所から出るすべてのパスについて、目的地の場所と
        // そこに到達するための出発点からの合計距離を含む新しいメモ
        //（NotebookEntry の形で）を作成します。checkNote() メソッドの
        // コメントを読んでこれがどのように機能するか確認してください。
        for (place_entry.place.paths) |*path| {
            working_note = NotebookEntry{
                .place = path.to,
                .coming_from = place_entry.place,
                .via_path = path,
                .dist_to_reach = place_entry.dist_to_reach + path.dist,
            };
            notebook.checkNote(working_note);
        }
    }

    // 上のループが完了したら、到達可能なすべての場所への最短パスが
    // 計算できています！次にすることは、旅のためのメモリを確保し、
    // 隠者のノートブックに目的地から出発点までの旅を埋めてもらうことです。
    // これが実際に目的地を使う最初の場所です！
    var trip: [place_count * 2]?TripItem = @splat(null);

    notebook.getTripTo(trip[0..], destination) catch |err| {
        print("Oh no! {}\n", .{err});
        return;
    };

    // 下の小さなヘルパー関数で旅を表示します。
    printTrip(trip[0..]);
}

// 旅は目的地から出発点まで、場所またはパスを含む TripItem が
// 交互に続く系列であることを覚えておいてください。
// trip 配列の残りのスペースには null 値が含まれるため、
// 目的地に到達するまで、アイテムを逆順にループして null をスキップする
// 必要があります。
fn printTrip(trip: []?TripItem) void {
    // @intCast() で usize の長さを u8 に変換します。
    // @import() と同様の組み込み関数です。
    // これについては後の演習で適切に学びます。
    var i: u8 = @intCast(trip.len);

    while (i > 0) {
        i -= 1;
        if (trip[i] == null) continue;
        trip[i].?.printMe();
    }

    print("\n", .{});
}

// 深掘り：
//
// コンピュータサイエンスの用語では、地図の場所は「ノード」または「頂点」であり、
// パスは「辺」です。合わせて「重み付き有向グラフ」を形成します。
// 各パスに距離（「コスト」とも呼ばれる）があるため「重み付き」です。
// 各パスが一つの場所から別の場所へ「向かう」ため「有向」です
//（無向グラフは辺をどちらの方向にも進めます）。
//
// ノートブックの末尾に新しいエントリを追加し、先頭から順番に探索する
//（「TODO リスト」のように）ので、ノートブックを「先入れ先出し（FIFO）」
// キューとして扱っています。
//
// より遠いものを試す前に最も近いパスをすべて調べるため
//（「TODO」キューのおかげで）、「幅優先探索（BFS）」を行っています。
//
// 「最低コスト」のパスを追跡することで、「最小コスト探索」も
// 行っていると言えます。
//
// さらに具体的には、隠者のノートブックは Shortest Path Faster Algorithm（SPFA）に
// 最も近く、Edward F. Moore によるものです。単純な FIFO キューを
// 「優先度付きキュー」に置き換えると、基本的にダイクストラのアルゴリズムに
// なります。優先度付きキューは「重み」でソートしてアイテムを取得します
//（この場合、最短距離のパスをキューの先頭に置きます）。
// ダイクストラのアルゴリズムはより効率的です。なぜなら、長いパスを
// より早く排除できるからです。（紙の上で解いてみてなぜかを確認してください！）
