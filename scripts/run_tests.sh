#!/usr/bin/env bash
# 用法: scripts/run_tests.sh <题目目录> [samples|tests|all]
# 编译题目目录下的 main.cpp / main.c（或直接运行 main.py），
# 逐个用 *.in 作为输入，与同名 *.out 比较（忽略行尾空白和末尾空行）。
set -uo pipefail

if [ $# -lt 1 ]; then
    echo "用法: $0 <题目目录> [samples|tests|all]" >&2
    exit 1
fi

dir="${1%/}"
which="${2:-all}"
timeout_sec="${TIMEOUT:-2}"

case "$which" in
    samples) sets=(samples) ;;
    tests)   sets=(tests) ;;
    all)     sets=(samples tests) ;;
    *) echo "未知参数: $which" >&2; exit 1 ;;
esac

build="$dir/build"
mkdir -p "$build"

if [ -f "$dir/main.cpp" ]; then
    g++ -std=c++17 -O2 -Wall -o "$build/main" "$dir/main.cpp" || { echo "编译失败 (CE)"; exit 1; }
    run=("$build/main")
elif [ -f "$dir/main.c" ]; then
    gcc -std=c11 -O2 -Wall -o "$build/main" "$dir/main.c" -lm || { echo "编译失败 (CE)"; exit 1; }
    run=("$build/main")
elif [ -f "$dir/main.py" ]; then
    run=(python3 "$dir/main.py")
else
    echo "找不到 main.cpp / main.c / main.py" >&2
    exit 1
fi

normalize() { sed -e 's/[[:space:]]*$//' "$1" | sed -e ':a' -e '/^\n*$/{$d;N;ba' -e '}'; }

pass=0; fail=0; total=0
for s in "${sets[@]}"; do
    [ -d "$dir/$s" ] || continue
    for in_file in "$dir/$s"/*.in; do
        [ -e "$in_file" ] || continue
        ans="${in_file%.in}.out"
        name="$s/$(basename "${in_file%.in}")"
        total=$((total + 1))
        if [ ! -f "$ans" ]; then
            echo "[SKIP] $name: 缺少 .out 文件"
            continue
        fi
        actual="$build/$(basename "${in_file%.in}").actual"
        timeout "$timeout_sec" "${run[@]}" < "$in_file" > "$actual" 2> "$build/stderr"
        code=$?
        if [ $code -eq 124 ]; then
            echo "[TLE ] $name"; fail=$((fail + 1))
        elif [ $code -ne 0 ]; then
            echo "[RE  ] $name (退出码 $code)"; fail=$((fail + 1))
        elif diff -q <(normalize "$actual") <(normalize "$ans") > /dev/null; then
            echo "[AC  ] $name"; pass=$((pass + 1))
        else
            echo "[WA  ] $name"
            diff <(normalize "$actual") <(normalize "$ans") | head -n 10
            fail=$((fail + 1))
        fi
    done
done

echo "----"
echo "通过 $pass / $total"
[ $fail -eq 0 ]
