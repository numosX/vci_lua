# Abstract
* Quaternion 覚え書き
* オブジェクトの座標系で「いくら回転したか」という回転量を表している。
* 演算は左から掛けて、右から複素共役を掛ける。Unity 上では左から掛けるだけでよい。
* ベクトルやクォータニオンに対して作用させることができ、実装上は回転行列の様に左から書けていけばよいだけ。

# Sample
* VCI Subitem の箱とVCI Subitem の板が入れ子になっていないVCIを考える。
* 箱を掴んで回転させると、箱と板の距離を保ったまま、板の向きを箱の向きを変えた分だけ回転させたい。
* 箱の向きはある基準となる向きから回転していると考え、その回転量がクォータニオンととらえる。
* サンプルコードでは、一度基準となる向きに戻してから操作後の向きにするクォータニオンを計算している。
* まず操作前の状態を取得しておき、
```lua
dr_vec      = plane_obj.GetPosition() - box_obj.GetPosition()
q_box_0     = box_obj.GetRotation()
q_plane_0   = plane_obj.GetRotation()
```
* 箱の回転量の変化分と変位量を用いて板の座標および向きを更新する。
```lua
r_box_1     = box_obj.GetPosition()
q_box_1     = box_obj.GetRotation()

dq_box      = q_box_1 * Quaternion.Inverse(q_box_0)

r_plane_1   = r_box_1 + dq_box * dr_vec
q_plane_1   = dq_box * q_plane_0

plane_obj.SetPosition(r_plane_1)
plane_obj.SetRotation(q_plane_1)
```

# 絵を用いた説明
* [数式不要、絵でわかるクォータニオンの使い方](https://youtu.be/Q1CQK6SxKJw)

# 数式を用いた説明
## Quaternion
  * ある方向を基準とする回転量があり、それを Quaternion $\tilde{q}$ で表現する。
  * Quaternion はスカラー部とベクトル部を分けて表記すると考えやすい。
  * $\tilde{q} = q_0 + \underline{q}$ と表現する
    * スカラー部 $q_0$
    * ベクトル部 $\underline{q} = q_1 \underline{i} + q_2 \underline{j} + q_3 \underline{k}$

##  逆Quarternion（Inverse）
  * ノルムが1となるように定義することで、逆方向の回転は共役をとるだけとなる。
  * $\tilde{q}^{-1} = \tilde{q}^* / ||\tilde{q}|| = \tilde{q}^{\ast}$

## 共役
  * ベクトル部の係数の符号を反転する。
  * $\tilde{q}^{\ast} = q_0 - \underline{q}$
  * 上の逆Quaternionの定義から、共役をとるとは逆回転させる量に変換すると読み替えられる。
  * アスタリスクが分かりにくかったら、逆回転をあらわす -1 と読み替えてもらって良い。

## 積の共役
  * 積の共役とは、平たく書くと、「p回転してq回転する」の逆回転のことである。
  * 「p回転してq回転する」の逆回転は、明らかに「q逆回転して、p逆回転する」である。
  * 数式しか使えない人は、下記の様に導いている。

$$
\begin{align}
  (\tilde{q}\otimes\tilde{p})^{\ast} &= [(q_0 + \underline{q}) \otimes (p_0 + \underline{p})]^{\ast} \notag \\
  &= (p_0 + \underline{p})^{\ast} \otimes (q_0 + \underline{q})^{\ast} \notag \\
  &= (p_0 - \underline{p}) \otimes (q_0 - \underline{q}) \notag \\
  &= \tilde{p}^{\ast} \otimes \tilde{q}^{\ast} \notag 
\end{align}
$$

* では下記ではどうだろうか？

$$ (\tilde{w}\otimes\tilde{v}\otimes\tilde{u}\otimes\tilde{t}\otimes\tilde{s}\otimes\tilde{r}\otimes\tilde{q}\otimes\tilde{p})^{\ast} = ? $$

* 数式でしか考えられないのなら、解くのは大変だ。
* 我々は既に物理的なイメージを持っているので、即答できることであろう。
* 作用させる前後でイメージを持つ、その時間発展を絵として見る。これらは数式の気持ちを理解するのに必要な事だ。

## 作用のさせ方
* 数学的には、ベクトル $\underline{v}$ に対する作用のさせ方と、Quaternion $\tilde{p}$ に対する作用のさせ方が異なる。

$$
\begin{align}
  \underline{v}'&=\tilde{q} \otimes \underline{v} \otimes \tilde{q}^{\ast}  \notag\\
  \tilde{q}'&=\tilde{q} \otimes \tilde{p}　\notag
  \end{align}
$$

* Unity では、いずれに対してもクォータニオン $\tilde{q}$ を左からかけるだけでよい。
```lua
local q   = Quaternion.identity
local p0  = Quaternion.identity
local v0  = Vector3.__new(0,0,0)
v1 = q * v0
p1 = q * p0
```

## 回転量の差
* 回転の基準となる方向を $\underline{r_0}$、回転前の箱の向きを $\underline{r_1}$、回転後の箱の向きを $\underline{r_2}$ とする。
* 以下では、 $\underline{r_1}$ から $\underline{r_2}$ に回転させるクォータニオンを求める。
* 基準の方向から各方向に向かせるためのクォータニオンをそれぞれ $\tilde{q_1}, \tilde{q_2}$ とする。

$$
\begin{aligned}
  \underline{r_1} = \tilde{q_1} \otimes \underline{r_0} \otimes \tilde{q_1}^* \notag\\
  \underline{r_2} = \tilde{q_2} \otimes \underline{r_0} \otimes \tilde{q_2}^* \notag\\
\end{aligned}
$$

* $\underline{r_1}$ の式に、左から $\tilde{q_1}^{-1}$をかけて、右から $\tilde{q_1}$ をかけると、

$$
\begin{aligned}
  \tilde{q_1}^* \otimes \underline{r_1} \otimes \tilde{q_1} =  \underline{r_0} \notag \\
\end{aligned}
$$

* $\underline{r_2}$ の式に代入して、 $\underline{r_0}$を消去すると、次の式が得られる。

$$ \underline{r}_2 = \tilde{q_2} \otimes \tilde{q_1}^{\ast} \otimes \underline{r_1} \otimes \tilde{q_1} \otimes \tilde{q_2}^{\ast} $$

* 一方、 $\underline{r_1}$ から $\underline{r_2}$ に回転させるクォータニオン $\tilde{q}_{12}$ をとすると、下記の様に表現することもできる。

$$ \underline{r_2} = \tilde{q_{12}} \otimes \underline{r_1} \otimes \tilde{q_{12}}^{\ast} $$

* 2式を比較すると、次のように書ける。

$$ \tilde{q}_{12} = \tilde{q}_2 \otimes \tilde{q}_1^{\ast} $$

* よって、回転している物体を更に回転させる場合、もともとある回転量を逆回転で消してしまい、新しい回転量を与えれば良いということになる。

## Unity での扱い
* Unity では、右から複素共役を掛ける事を省略することができる（内部では計算している）。
* これにより、縦ベクトルに回転行列を作用させるときの様に、見かけ上は左からクォータニオンを掛けていけばよいだけとなる。

## あとがき

* これを書いていた当時、クォータニオンをググると、クォータニオンの詳細な定義から入り、演算方法をつらつらと列挙しているブログが散見されていた。
* わかったようなことを書いていながら、わかってない記事も多く、読めば読むほど余計に混乱した記憶がある。
* まずは「使い方はこうです」って説明があっても良いのではないか。そんな問いかけを込めて、切り抜きを投稿した次第である。
* たしかに、ときには難しい計算をすることも必要である。けれども、結局のところは、使えてなんぼ。頭ではなく心で数式を読み、縦横無尽に使いこなしていきたいものだ。

# References
* [クォータニオン計算便利ノート](https://www.mesw.co.jp/business/report/pdf/mss_18_07.pdf)
