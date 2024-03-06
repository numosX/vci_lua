# Abstract
* ピストル

# Get Started
* ピストルの GameObject は、gun という名前とする
* ピストルの弾の GameObject は、bullet という名前とする

```lua
-- 初期化
local Shooter	= require "item_shooter"
local shooter	= Shooter:new()

-- 発射する起点となる obj を指定
local gun = vci.assets.GetTransform("gun")
shooter:set_shot_origin(gun)

-- 弾をピストルに装填
local ballet = vci.assets.GetTransform("bullet")
shooter:set_ballet(ballet)

function onUse(used_gun)
    -- 発射
    shooter:shot()
end
```


## Methods
```lua
shooter:set_shot_origin(obj)	-- vci.assets.GetTransform で取得したobjを起点とする
shooter:set_ballet(obj) 		-- 弾として使うobjを指定する
shooter:set_velocity(number)	-- 弾の速度を指定する
shooter:shot()					-- 発射する
```