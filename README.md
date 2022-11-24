# textbook

本リポジトリは関連参考文献([URL](https://www.coronasha.co.jp/np/isbn/9784339033847/))で扱うサンプルコードおよび、グラフ作成に用いたコードをまとめています。

## 各フォルダの内容
- code_textbook
  - テキスト内のサンプルコード
- figure_textbook
  - テキスト内のグラフ作成用コード
  - このフォルダ内のコードは一部のファイルを除き、ほとんどが[GUILDA](https://lim.ishizaki-lab.jp/guilda)を用いて作成されています。

***

## __code_textbook内ファイル対応表__
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


## __figure_textbook内ファイル対応表(準備中)__
| ファイル名 | 電力テキスト内の対応箇所 | 図表番号 |GUILDAの使用|
| :--- | :---: | :--- | :---: |
| example_2_3.m | 例2.3 | 図2.10, 図2.11, 図2.12 |●|
| example_3_3.m | 例3.3 | 図3.2 |●|
| example_3_4.m | 例3.4 | 図3.3, 図3.4 |●|
| example_3_5.m | 例3.5 | 図3.5, 図3.6 |●|
| example_4_2.m | 例4.2 | 図4.2, 図4.3(省略) |●|
| example_4_3.m | 例4.3 | 図4.5 |●|
| example_4_4.m | 例4.4 | 図4.9 ||
| example_4_5.m | 例4.5 | 図4.10 ||
| example_4_6.m | 例4.6 | 図4.11 ||
| example_5_1.m | 例5.1 | 図5.2 |●|
| example_5_2.m | 例5.2 | 図5.3 |●|
| example_5_3.m | 例5.3 | 図5.5 |●|
| example_5_4.m | 例5.4 | 図5.8, 図5.9, 図5.10 |●|
| example_5_5.m | 例5.5 | 図5.12 |●|
| example_5_6.m | 例5.6 | 図5.15, 図5.16 |●|
| example_6_2.m | 6.2節 | 図6.2, 図6.3 |●|
| example_6_3.m | 6.3節 | 図6.4 |●|
| | | | |
| ネットワーク定義ファイル | |利用する箇所|●|
|network_3bus_example_2.m  |>| 例3.2|●|
|network_3bus_example_3_1.m|>| 例3.3, 例3.4, 例3.5, 例5.3, 例5.4|●|
|network_3bus_example_3_2.m|>| 例3.3, 例3.4, 例3.5, 例5.3|●|
|network_3bus_example_4.m  |>| 例|●|
|network_3bus_example_5_3.m|>| 例5.4|●|
|network_3bus_example_5_6.m|>| 例|●|
|network_3bus_example_5.m  |>| 例5.1, 例5.2, 例5.3|●|
