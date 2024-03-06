# Abstract
* 連番で名前の付いた VCI subitem を順次取り出すためのスクリプト
* 例えばピストルの弾を処理する際やパーティクルライブを作成する際に便利

# Get Started
* VCI subitem が付いた GameObject が沢山あるケースを考える
* GameObject はそれぞれ、tem0, item1,...,item99 という名前だとする

```lua
local ItemLoader        = require "item_loader"
local my_item_loader    = ItemLoader:new()

my_item_loader:add("item", 100) -- item0 から item99 を内部のテーブルに登録

function onUse(used_obj)
    obj = my_item_loader:get() -- 登録したテーブルから item が１つ取得される
    do_something(obj)
end

function do_something(obj)
    -- 例えばエフェクトを再生させる場合
    local effect	= vci.assets.GetEffekseerEmitter(obj.GetName())
    effect._ALL_Stop()
    effect._ALL_Play()
end

```
* 上記例では101回useすると、item0に再び処理がかかる


## Methods
```lua
my_item_loader:add(string, int) 	-- "{string}{number}"の連番で名前が付いたGameObjectを登録、0から指定したint-1までが登録される
my_item_loader:get() 				-- 登録したGameObjectを1つ取得、取得するオブジェクトは登録した順番に取り出される
```