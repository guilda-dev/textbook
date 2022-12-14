# textbook

## 目次
- [本リポジトリの概要](#anchor1)
- [各フォルダの内容](#anchor2)
- [各プログラムの実行方法](#anchor3)
- [`"codes_textbook"`フォルダ内のファイル対応表](#anchor4)
- [`"figures_textbook"`フォルダ内のファイル対応表](#anchor5)

***

<a id="anchor1"></a>
## 本リポジトリの概要

本リポジトリは関連参考文献([URL](https://www.coronasha.co.jp/np/isbn/9784339033847/))で扱うサンプルコードおよび、グラフ作成に用いたコードをまとめています。

***

<a id="anchor2"></a>
## 各フォルダの内容
- codes_textbook
  - テキスト内のサンプルコード
- figures_textbook
  - テキスト内のグラフ作成用コード
  - このフォルダ内のコードは一部のファイルを除き、ほとんどが[GUILDA](https://lim.ishizaki-lab.jp/guilda)を用いて作成されています。

***

<a id="anchor3"></a>
## 各プログラムの実行方法
- codes_textbook フォルダ内のプログラムの実行
  - コマンドウィンドウにて `exe_codes_textbook` を実行します
  - [`"codes_textbook"`フォルダ内のファイル対応表](#anchor4)を参考にして、実行したいプログラムに対応する例の番号を入力してください
  - プログラムが実行され、エディターに該当プログラムが開かれます
- codes_textbook フォルダ内のプログラムの実行
  - コマンドウィンドウにて `exe_figures_textbook` を実行します
  - [`"figures_textbook"`フォルダ内のファイル対応表](#anchor5)を参考にして、生成したいグラフに対応する例や節の番号を入力してください
  - プログラムが実行され、グラフが生成され、エディターに該当プログラムが開かれます

***

<a id="anchor4"></a>
## __`"codes_textbook"`フォルダ内のファイル対応表__

|フォルダ名|ファイル名|電力テキスト内のプログラム番号|
|:----|:----|:----|
|example3.8|func_ex1.m|プログラム3-1|
| |main_ex1.m|プログラム3-2|
|example3.9|func_ex2.m|プログラム3-3|
| |main_ex2.m|プログラム3-4|
|example3.10|func_ex3.m|プログラム3-5|
| |main_ex3.m|プログラム3-6|
|example3.11|bus_slack.m|プログラム3-7|
| |bus_generator.m|プログラム3-8|
| |bus_load.m|プログラム3-9|
| |func_power_flow.m|プログラム3-10|
| |main_ex4.m|プログラム3-11|
|example3.12|branch.m|プログラム3-12|
| |get_admittance_matrix.m|プログラム3-13|
| |main_admittance.m|プログラム3-14|
|example3.13|calculate_power_flow.m|プログラム3-15|
| |main_power_flow.m|プログラム3-16|
| |branch.m| |
| |bus_generator.m| |
| |bus_load.m| |
| |bus_slack.m| |
| |func_power_flow.m| |
| |get_admittance_matrix.m| |
|example3.14|func_RLC_ode.m|プログラム3-17|
| |main_RLC_ode.m|プログラム3-18|
| |func_RLC_dae.m|プログラム3-19|
| |main_RLC_dae.m|プログラム3-20|
|example3.15|func_simulation_3bus.m|プログラム3-21|
| |main_simulation_3bus_simple.m|プログラム3-22|
| |branch.m| |
| |get_admittance_matrix.m| |
|example3.16|generator.m|プログラム3-23|
| |load_impedance.m|プログラム3-24|
| |func_simulation.m|プログラム3-25|
| |simulate_power_system.m|プログラム3-26|
| |main_simulation_3bus.m|プログラム3-27|
| |branch.m| |
| |get_admittance_matrix.m| |
|example3.17|generator.m|プログラム3-28|
| |load_impedance.m|プログラム3-29|
| |main_simulation_3bus_equilibrium.m|プログラム3-30|
| |branch.m| |
| |bus_generator.m| |
| |bus_load.m| |
| |bus_slack.m| |
| |calculate_power_flow.m| |
| |func_power_flow.m| |
| |func_simulation.m| |
| |get_admittance_matrix.m| |
| |simulate_power_system.m| |
|example3.18|func_simulation.m|プログラム3-31|
| |simulate_power_system.m|プログラム3-32|
| |main_simulation_3bus_fault.m|プログラム3-33|
| |branch.m| |
| |bus_generator.m| |
| |bus_load.m| |
| |bus_slack.m| |
| |calculate_power_flow.m| |
| |func_power_flow.m| |
| |generator.m| |
| |get_admittance_matrix.m| |
| |load_impedance.m| |
|example3.19|generator.m|プログラム3-34|
| |load_impedance.m|プログラム3-35|
| |func_simulation.m|プログラム3-36|
| |simulate_power_system.m|プログラム3-37|
| |main_simulation_3bus_input.m|プログラム3-38|
| |branch.m| |
| |bus_generator.m| |
| |bus_load.m| |
| |bus_slack.m| |
| |calculate_power_flow.m| |
| |func_power_flow.m| |
| |get_admittance_matrix.m| |

<br>
<br>

***

<br>

<a id="anchor5"></a>
## __`"figures_textbook"`フォルダ内のファイル対応表__

#### ネットワーク定義用ファイル`network_example3bus.m`

```
net = network_example3bus('flow',Value,'comp2',Value,'lossless',Value)
```

##### ・`flow` : 潮流設定の指定
|Value|指定内容|
|:---|:---|
|0|テキスト表2.2の入力定常値に対応する潮流設定|
|1|テキスト表3.1の潮流設定|
|2|テキスト表3.2の潮流設定|

##### ・`comp2` : 母線2に付加する機器の指定
|Value|指定内容|
|:---|:---|
|`'L_impedance'`|母線２に定インピーダンス負荷モデルを付加|
|`'L_power'`|母線2に定電力負荷を付加|
|`'Gen_1axis'`|母線２に同期発電機モデルを付加|

##### ・`lossless` : 送電網の損失の有無の指定
|Value|指定内容||
|:---|:---|:---|
||母線1-2間|母線2-3間|
|`{}`|損失あり|損失あり|
|`{'br12'}`|損失なし|損失あり|
|`{'br23'}`|損失あり|損失なし|
|`{'br12','br23'}`|損失なし|損失なし|


#### グラフ作成ファイル

| ファイル名 | 対応<br>箇所 | 図表<br>番号 |GUILDA<br>の使用|モデル設定||||
| :--- | :---: | :--- | :---: |:---:|:---|:---|:---|
|||||`flow`|`comp2`|`lossless`|制御器[^1]|
| example_2_3.m | 例2.3 | 図2.10<br>図2.11<br>図2.12 |●|0|`Gen_1axis`|`{}`|なし|
| example_3_3.m | 例3.3 | 図3.2 |●|1 , 2|`L_impedance`|`{'br23'}`|なし|
| example_3_4.m | 例3.4 | 図3.3<br>図3.4 |●|1 , 2|`L_impedance`|`{'br23'}`|なし|
| example_3_5.m | 例3.5 | 図3.5<br>図3.6 |●|1 , 2|`L_impedance`|`{'br23'}`|なし|
| example_4_2.m | 例4.2 | 図4.2<br>図4.3(略) |●|0|`Gen_1axis`|`{}`|なし|
| example_4_3.m | 例4.3 | 図4.5 |×|-|-|-|-|
| example_4_4.m | 例4.4 | 図4.9 |×|-|-|-|-|
| example_4_5.m | 例4.5 | 図4.10 |×|-|-|-|-|
| example_4_6.m | 例4.6 | 図4.11 |×|-|-|-|-|
| example_5_1.m | 例5.1 | 図5.2 |●|2|`L_power`|`{'br23'}`|AGC|
| example_5_2.m | 例5.2 | 図5.3 |●|2|`L_power`|`{'br23'}`|AGC|
| example_5_3.m | 例5.3 | 図5.5 |●|2|`L_power`|`{'br12',`<br>`'br23'}`|AGC|
| example_5_4.m | 例5.4 | 図5.8<br>図5.9<br>図5.10 |●|1|`L_impedance`|`{'br23'}`|PSS<br>AVR|
| example_5_5.m | 例5.5 | 図5.12 |●|1|`L_impedance`|`{'br23'}`|PSS<br>AVR|
| example_5_6.m | 例5.6 | 図5.15<br>図5.16 |●|2|`L_impedance`|`{'br23'}`|AVR<br>AGC<br>retrofit|
| example_6_2.m | 6.2節 | 図6.2<br>図6.3 |●|[^2]|-|-|PSS<br>AVR<br>AGC|
| example_6_3.m | 6.3節 | 図6.4 |●|[^3]|-|-|PSS<br>AVR<br>retrofit|


[^1]:制御器は`network_example3bus`内では無く後から付加する。
[^2]: `example_6_2.m`では __「IEEE68busモデル」__ を電力モデルとして使用。
[^3]:`example_6_3.m`でも __「IEEE68busモデル」__ を電力モデルとして使用。


```
%IEEE68busモデルの定義
net = network_IEEE68bus();
```