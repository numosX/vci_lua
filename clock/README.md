# Clock
## Abstract
* sleep を使わずに実行タイミングを制御するためのスクリプト

## Get Started
* 例えば、10 s 毎に処理を行いたい場合
  * 1 s オンになって、9 s オフになる、周期 10 s のクロック信号を作る
  * オンになる瞬間をトリガーとして処理を実行する
```lua
Clock = require("clock")
clock = Clock:new()
clock:set_high_time(1)
clock:set_low_time(9)

while(true)
do
    if clock:is_rising() then
        print(os.clock() .. " rising")
    end
end
```

* 上記実装では最初の 0 s 付近もトリガーされる
* 最初の 0 s 付近で実行されたくない場合は下記の様に実装する
  * 9 s オフになって、1 s オンになる、周期 10 s のクロック信号を作る
  * ```オフ```になる瞬間をトリガーとして処理を実行する
```lua
Clock = require("clock")
clock = Clock:new()
clock:select_clock("pulse_low_start")
clock:set_low_time(9)
clock:set_high_time(1)

while(true)
do
    if clock:is_falling() then
        print(os.clock() .. " falling")
    end
end
```

## Methods
* 制御用
```lua
clock:is_rising()  -- オンになった瞬間 true を返す
clock:is_falling() -- オフになった瞬間 true を返す
```
* パラメタ設定用
```lua
clock:set_threshold(number) -- オンオフの切り替えを判断する縦軸の値の閾値
clock:set_high_time(number) -- pulse clock 用 オンになる時間を設定(s)
clock:set_low_time(number)  -- pulse clock 用 オフになる時間を設定(s)
clock:set_frequency(number) -- saw clock 用 周波数を設定(Hz)
```
* その他
```lua
clock:get_clock()           -- クロック信号を取り出す
clock:select_clock(string)  -- クロックの種類を変える
```

## Implemented Clocks
### Pulse ( HIGH-LOW )
* オンから始まるパルス（low:0, high:1）
```lua
clock:select_clock("pulse")
clock:set_high_time(1)
clock:set_low_time(9)
clock:set_threshold(0.5)
```

### Pulse ( LOW-HIGH )
* オフから始まるパルス（low:0, high:1）
```lua
clock:select_clock("pulse_low_start")
clock:set_low_time(9)
clock:set_high_time(1)
clock:set_threshold(0.5)
```

### Saw
* ギザギザの信号（min:0, max:1）
* 周期は```set_frequency```で指定する。
```lua
clock:select_clock("saw")
clock:set_frequency(10)
clock:set_threshold(0.5)
```