//
// コンパイル時に型を関数に渡せることで、複数の型で動作する
// コードを生成できます。しかし、異なる型の値を関数に
// 渡すのには役立ちません。
//
// そのために 'anytype' プレースホルダーがあります。これは
// Zigにパラメータの実際の型をコンパイル時に推論するよう
// 指示します。
//
//     fn foo(thing: anytype) void { ... }
//
// そして @TypeOf()、@typeInfo()、@typeName()、@hasDecl()、
// @hasField() などの組み込み関数を使って、渡された型について
// 詳細を調べることができます。このロジックはすべて
// コンパイル時に実行されます。
//
const print = @import("std").debug.print;

// Duck、RubberDuck、Duct の3つの構造体を定義しましょう。
// Duck と RubberDuck は両方とも waddle() と quack() メソッドを
// 名前空間（「decls」とも呼ばれます）に宣言していることに
// 注意してください。

const Duck = struct {
    eggs: u8,
    loudness: u8,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *Duck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: Duck) void {
        if (self.loudness < 4) {
            print("\"Quack.\" ", .{});
        } else {
            print("\"QUACK!\" ", .{});
        }
    }
};

const RubberDuck = struct {
    in_bath: bool = false,
    location_x: i32 = 0,
    location_y: i32 = 0,

    fn waddle(self: *RubberDuck, x: i16, y: i16) void {
        self.location_x += x;
        self.location_y += y;
    }

    fn quack(self: RubberDuck) void {
        // 式を '_' に代入することで、値を安全に
        // 「使用」しながら無視することができます。
        _ = self;
        print("\"Squeek!\" ", .{});
    }

    fn listen(self: RubberDuck, dev_talk: []const u8) void {
        // プログラミングの問題についての開発者の話を聞く。
        // 問題を静かに熟考する。役立つ音を出す。
        _ = dev_talk;
        self.quack();
    }
};

const Duct = struct {
    diameter: u32,
    length: u32,
    galvanized: bool,
    connection: ?*Duct = null,

    fn connect(self: *Duct, other: *Duct) !void {
        if (self.diameter == other.diameter) {
            self.connection = other;
        } else {
            return DuctError.UnmatchedDiameters;
        }
    }
};

const DuctError = error{UnmatchedDiameters};

pub fn main() void {
    // 本物のアヒルです！
    const ducky1 = Duck{
        .eggs = 0,
        .loudness = 3,
    };

    // 本物のアヒルではありませんが、quack() と waddle() の
    // 能力があるので、やはり「アヒル」です。
    const ducky2 = RubberDuck{
        .in_bath = false,
    };

    // アヒルとはまったく関係ありません。
    const ducky3 = Duct{
        .diameter = 17,
        .length = 165,
        .galvanized = true,
    };

    print("ducky1: {}, ", .{isADuck(ducky1)});
    print("ducky2: {}, ", .{isADuck(ducky2)});
    print("ducky3: {}\n", .{isADuck(ducky3)});
}

// この関数はコンパイル時に推論される単一のパラメータを持ちます。
// @TypeOf() と @hasDecl() 組み込み関数を使ってダック・タイピング
// （「アヒルのように歩き、アヒルのように鳴くなら、
// アヒルに違いない」）を実行し、型が「アヒル」かどうかを
// 判断します。
fn isADuck(possible_duck: anytype) bool {
    // @hasDecl() を使って型が「アヒル」になるために
    // 必要なすべてを持っているかどうかを判断します。
    //
    // この例では、Foo 型に increment() メソッドがある場合、
    // 'has_increment' は true になります：
    //
    //     const has_increment = @hasDecl(Foo, "increment");
    //
    // MyType が waddle() と quack() の両方のメソッドを
    // 持っていることを確認してください：
    const MyType = @TypeOf(possible_duck);
    const walks_like_duck = ???;
    const quacks_like_duck = ???;

    const is_duck = walks_like_duck and quacks_like_duck;

    if (is_duck) {
        // ここでも quack() メソッドを呼び出して、Zig が
        // 十分にアヒルらしいものに対してアヒルの動作を
        // 実行できることを証明します。
        //
        // すべての確認と推論はコンパイル時に実行されるので、
        // 完全な型安全性があります：quack() メソッドを持たない
        // 構造体（Ductのような）でこのメソッドを呼び出そうとすると、
        // 実行時のパニックやクラッシュではなく、コンパイルエラーに
        // なります！
        possible_duck.quack();
    }

    return is_duck;
}
