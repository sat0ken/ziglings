//
// クイズタイム — 非同期 I/O！
//
// Zoraptera 博士の昆虫シミュレーションは順調ですが、
// 仮想の庭には気象データが必要だと気づきました！昆虫は
// 気温、湿度、風の状態によって異なる行動をします。
//
// 彼女は庭の周りに3つの気象センサーを設置し、
// 並行して状況を測定し、共有データチャネルを通じて
// 読み取り値を報告します。コレクタータスクが読み取り値を集め、
// すべてのセンサーが報告した後、庭のレポートが出力されます。
//
// しかし博士 Z はコードを急いで書きました（バッタに追いかけられていました）
// いくつかのバグが残っています。修正できますか？
//
// プログラムがすべきこと：
//   1. 3つのセンサータスクがそれぞれ正確に3つの読み取り値を
//      Queue を通じて送信する
//   2. コレクタータスクが並行して読み取り値を受け取り、
//      Mutex で保護する
//   3. すべてのセンサーが終わったら、キューを閉じる
//   4. 最終レポートをキャンセル保護されたセクションで書き込む
//
// *************************************************************
// *               この演習についての注意                      *
// *                                                           *
// * このクイズは演習085〜094の概念を使います。                *
// * 修正すべきバグが6つあります — ???を探してください！       *
// *                                                           *
// *************************************************************
//
const std = @import("std");
const print = std.debug.print;

const SensorType = enum { thermometer, hygrometer, anemometer };

const Reading = struct {
    sensor_type: SensorType,
    value: i32,
};

const GardenWeather = struct {
    temperature: i32 = 0,
    humidity: i32 = 0,
    wind: i32 = 0,
    readings_count: u32 = 0,
    mutex: std.Io.Mutex = .init,

    fn addReading(self: *GardenWeather, io: std.Io, reading: Reading) void {
        // バグ1：コレクターは共有状態を変更する前にロックする必要があります。
        // ロックを取得する Mutex のメソッドは何ですか？
        self.mutex.???(io) catch return;
        defer self.mutex.unlock(io);

        switch (reading.sensor_type) {
            .thermometer => self.temperature = reading.value,
            .hygrometer => self.humidity = reading.value,
            .anemometer => self.wind = reading.value,
        }
        self.readings_count += 1;
    }
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var weather = GardenWeather{};

    var reading_buf: [8]Reading = undefined;
    var queue: std.Io.Queue(Reading) = .init(&reading_buf);

    // コレクターはセンサーがまだ送信中に読み取り値を処理できるよう
    // 並行して実行する必要があります。
    // 並行処理ユニットを確保するために最初に起動します。
    //
    // バグ2：コレクターは保証された並行処理が必要です。
    // 別の並行処理ユニットを保証するメソッドは何ですか？
    // （忘れずに：失敗することがあります！）
    var collector_future = try io.???(collector, .{ io, &queue, &weather });
    defer _ = collector_future.cancel(io);

    // センサーグループ：センサーは async を使えます —
    // 実行するだけでよく、async の方が移植性が高いです。
    var sensors: std.Io.Group = .init;

    sensors.async(io, sensor, .{ io, &queue, .thermometer, 20 });
    sensors.async(io, sensor, .{ io, &queue, .hygrometer, 60 });
    sensors.async(io, sensor, .{ io, &queue, .anemometer, 10 });

    // バグ3：すべてのセンサーが読み取り値の送信を終えるまで待ちます。
    // すべてのタスクが完了するまでブロックする Group のメソッドは何ですか？
    try sensors.???(io);

    // すべてのセンサーが完了 — キューを閉じてコレクターに
    // データがもうないことを知らせます。
    queue.close(io);

    // バグ4：コレクターが残りのキューをドレインするのを待つには？
    _ = collector_future.???(io);

    // 今、庭のレポートを書きます。これは重要です —
    // 何かがキャンセルしようとしても割り込まれてはいけません！
    //
    // バグ5：このセクションをキャンセルから保護します。
    // キャンセル保護状態を切り替える Io のメソッドは何ですか？
    const old_protection = io.???(.blocked);
    defer _ = io.???(old_protection);

    printGardenReport(&weather);
}

fn sensor(
    io: std.Io,
    queue: *std.Io.Queue(Reading),
    sensor_type: SensorType,
    base_value: i32,
) void {
    // 各センサーはちょうど3回測定します。
    for (1..4) |i| {
        io.sleep(std.Io.Duration.fromMilliseconds(100), .awake) catch return;

        const reading = Reading{
            .sensor_type = sensor_type,
            .value = base_value + @as(i32, @intCast(i)),
        };

        // バグ6：読み取り値をキューに送信します。
        // 単一の要素を送信する Queue のメソッドは何ですか？
        queue.???(io, reading) catch return;
    }
}

fn collector(
    io: std.Io,
    queue: *std.Io.Queue(Reading),
    weather: *GardenWeather,
) void {
    while (true) {
        const reading = queue.getOne(io) catch |err| switch (err) {
            error.Closed => break,
            error.Canceled => return,
        };
        weather.addReading(io, reading);
    }
}

fn printGardenReport(weather: *GardenWeather) void {
    print("=== Doctor Zoraptera's Garden Report ===\n", .{});
    print("Temperature : {}C\n", .{weather.temperature});
    print("Humidity    : {}%\n", .{weather.humidity});
    print("Wind        : {} km/h\n", .{weather.wind});
    print("Readings    : {}\n", .{weather.readings_count});

    if (weather.temperature > 20 and weather.wind < 15) {
        print("Bee-friendly conditions! Expect high pollination.\n", .{});
    } else {
        print("Grasshoppers will be grumpy today.\n", .{});
    }
}

// 興味のある方へのさらなる読み物：
//
// このクイズでは主な非同期 I/O プリミティブを扱いました：
//   io.async()              - タスクを起動（インラインで実行される場合あり）
//   io.concurrent()         - 保証された並行処理ユニット
//   Future.await/cancel     - 単一タスクの収集またはキャンセル
//   Group.async/await/cancel - ファイアアンドフォーゲットタスクの管理
//   Select.async/await      - タスクをレースさせ、最初の完了に対して処理
//   Queue                   - タスク間の有界チャネル
//   Mutex                   - 共有状態の保護
//   CancelProtection        - クリティカルセクションの保護
//
// カバーしなかった同期プリミティブがさらにあります：
//   Condition  - 条件が真になるまで待機
//   RwLock     - 複数の読み取り側または一つの書き込み側
//   Semaphore  - リソースへの並行アクセスを制限
//   Futex      - メモリアドレスに対する低レベルの待機/通知
//   Batch      - 複数の I/O 操作を一度に送信
//
// 重要な洞察：これらはすべて Io VTable を通じて動作するため、
// コードはバックエンド間で移植可能です — Threaded（OS スレッドプール）でも、
// Evented（単一の OS スレッドでも並行処理を提供できる M:N グリーンスレッド/ファイバー）でも。
//
// Zoraptera 博士も承認しています。
