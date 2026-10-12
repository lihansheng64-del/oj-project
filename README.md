# OJ 作业

## 目录结构

```
.
├── problems/            # 每道题一个目录
│   └── 0001-a-plus-b/
│       ├── README.md    # 题面、思路、复杂度
│       ├── main.cpp     # 代码（也支持 main.c / main.py）
│       ├── samples/     # 题面给出的样例：1.in / 1.out ...
│       └── tests/       # 自己补充的测试数据：1.in / 1.out ...
├── template/            # 新建题目时复制的模板
└── scripts/
    ├── new_problem.sh   # 新建题目
    ├── run_tests.sh     # 编译并运行样例 / 测试
    └── stress.sh        # 对拍（需要 brute.cpp 和 gen.py）
```

## 分支

| 分支 | 用途 |
| --- | --- |
| `master` | 主分支，放最终提交的代码 |
| `sample` | 样例分支：题面里给的样例数据（`samples/`） |
| `test`   | 测试分支：在样例基础上补充的测试数据（`tests/`）和对拍脚本 |

推荐流程：在 `sample` 分支加题目和样例 → 合并进 `test` 分支补测试并通过 → 合并回 `master`。

## 用法

```bash
# 新建题目
scripts/new_problem.sh 0002-two-sum

# 只跑样例
scripts/run_tests.sh problems/0001-a-plus-b samples

# 只跑测试数据
scripts/run_tests.sh problems/0001-a-plus-b tests

# 全部跑（默认）
scripts/run_tests.sh problems/0001-a-plus-b
```

每个测试点输出 `AC` / `WA` / `TLE` / `RE`，比较时忽略行尾空格和末尾空行。
单个测试点默认限时 2 秒，可用 `TIMEOUT=1 scripts/run_tests.sh ...` 修改。

## 对拍

在题目目录下放 `brute.cpp`（暴力解）和 `gen.py`（随机数据生成器，第一个参数是种子），然后：

```bash
scripts/stress.sh problems/0001-a-plus-b 500
```

出现不一致时会打印那组输入和两边的输出。
