# Abstract
* Quaternion 覚え書き

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
* 箱の回転量と変位量を用いて板の座標および向きを更新する。
```lua
r_box_1     = box_obj.GetPosition()
q_box_1     = box_obj.GetRotation()

dq_box      = q_box_1 * Quaternion.Inverse(q_box_0)

r_plane_1   = r_box_1 + dq_box * dr_vec
q_plane_1   = dq_box * q_plane_0

plane_obj.SetPosition(r_plane_1)
plane_obj.SetRotation(q_plane_1)
```

# 詳説
## Quaternion
  * ある方向を基準とする回転量があり、Quaternion $\tilde{q}$ で表現できる。
  * Quaternion はスカラー部とベクトル部を分けて表記すると考えやすい。
  * $\tilde{q} = q_0 + \mathbf{q}$ と表現する
    * スカラー部 $q_0$
    * ベクトル部 $\mathbf{q} = q_1 \mathbf{i} + q_1 \mathbf{j} + q_1 \mathbf{k}$
##  逆Quarternion（Inverse）
  * ノルムが1となるように定義することで、逆方向の回転は共役をとるだけとなる。
  * $\tilde{q}^{-1} = \tilde{q}^* / ||\tilde{q}|| = \tilde{q}^{\ast}$
## 共役
  * ベクトル部の係数の符号を反転する。
  * $\tilde{q}^{\ast} = q_0 - \mathbf{q}$
## 積の共役
  * 積の共役のとりかたは、並べ替えて、全部に共役をとる。

$$
\begin{align}
  (\tilde{q}\otimes\tilde{p})^{\ast} &= [(q_0 + \mathbf{q}) \otimes (p_0 + \mathbf{p})]^{\ast} \notag \\
  &= (p_0 + \mathbf{p})^{\ast} \otimes (q_0 + \mathbf{q})^{\ast} \notag \\
  &= (p_0 - \mathbf{p}) \otimes (q_0 - \mathbf{q}) \notag \\
  &= \tilde{p}^{\ast} \otimes \tilde{q}^{\ast} \notag 
\end{align}
$$

## 作用のさせ方
* 数学的には、ベクトル $v$ に対する作用のさせ方と、Quaternion $\tilde{p}$ に対する作用のさせ方が異なる。

$$
\begin{align}
  v'&=\tilde{q} \otimes v \otimes \tilde{q}^{\ast}  \\
  q'&=\tilde{q} \otimes \tilde{p}
  \end{align}
$$

* Unity では、いずれに対してもクォータニオン $\tilde{q}$ を左からかけるだけでよい。
```lua
local q   = Quaternion.identity
local p0  = Quaternion.identity
local v0  = Vector.__new(0,0,0)
v1 = q * v0
p1 = q * p0
```

## 回転量の差
* 回転の基準となる方向を $r_0$、回転前の箱の向きを $r_1$、回転後の箱の向きを $r_2$ とする。
* 基準の方向から各方向に向かせるためのクォータニオンをそれぞれ $\tilde{q}_1, \tilde{q}_2$ とする。

$$
\begin{aligned}
  r_1 = \tilde{q_1} \otimes r_0 \otimes \tilde{q_1}^* \notag\\
  r_2 = \tilde{q_2} \otimes r_0 \otimes \tilde{q_2}^* \notag\\
\end{aligned}
$$

* $r_1$ の式に、左から $\tilde{q_1}^{-1}$をかけて、右から $\tilde{q_1}$ をかけると、

$$
\begin{aligned}
  \tilde{q_1}^* \otimes r_1 \otimes \tilde{q_1} =  r_0 \notag \\
\end{aligned}
$$

*  $r_2$の式に代入して $r_0$ を消去すると

$$
\begin{aligned}
  r_2 &= \tilde{q_2} \otimes \tilde{q_1}^* \otimes r_1 \otimes \tilde{q_1} \otimes \tilde{q_2}^* \notag \\
  &=\tilde{q}_{12} \otimes r_0 \otimes \tilde{q}_{12}^* \notag\\
\end{aligned}
$$

* $r_1$から $r_2$に回転させるクォータニオン $dq$ は $\tilde{q}_2\otimes \tilde{q}_1^{\ast}$ となる。
* 幾何学的にこれを考えると、ある回転量はある基準に戻してから新しい回転量を与えれば良いということになる。


# References
* [クォータニオン計算便利ノート](https://www.mesw.co.jp/business/report/pdf/mss_18_07.pdf)