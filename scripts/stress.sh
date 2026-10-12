#!/usr/bin/env bash
# 对拍：用随机数据比较 main 和暴力解 brute 的输出，找出第一组不一致的数据。
# 用法: scripts/stress.sh <题目目录> [次数]
# 题目目录下需要:
#   main.cpp  —— 待测代码
#   brute.cpp —— 暴力 / 必定正确的解
#   gen.py    —— 随机数据生成器，第一个参数是随机种子，输出到 stdout
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "用法: $0 <题目目录> [次数]" >&2
    exit 1
fi

dir="${1%/}"
rounds="${2:-500}"
build="$dir/build"
mkdir -p "$build"

for f in main.cpp brute.cpp gen.py; do
    [ -f "$dir/$f" ] || { echo "缺少 $dir/$f" >&2; exit 1; }
done

g++ -std=c++17 -O2 -o "$build/main" "$dir/main.cpp"
g++ -std=c++17 -O2 -o "$build/brute" "$dir/brute.cpp"

for ((i = 1; i <= rounds; i++)); do
    python3 "$dir/gen.py" "$i" > "$build/stress.in"
    "$build/main" < "$build/stress.in" > "$build/stress.main"
    "$build/brute" < "$build/stress.in" > "$build/stress.brute"
    if ! diff -wq "$build/stress.main" "$build/stress.brute" > /dev/null; then
        echo "第 $i 组不一致（种子 $i）"
        echo "== 输入 =="; cat "$build/stress.in"
        echo "== main =="; cat "$build/stress.main"
        echo "== brute =="; cat "$build/stress.brute"
        exit 1
    fi
done
echo "对拍 $rounds 组全部一致"
