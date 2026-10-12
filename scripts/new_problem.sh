#!/usr/bin/env bash
# 用法: scripts/new_problem.sh <题目目录名>
# 例如: scripts/new_problem.sh 0002-two-sum
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "用法: $0 <题目目录名>" >&2
    exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="$root/problems/$1"

if [ -e "$dest" ]; then
    echo "已存在: problems/$1" >&2
    exit 1
fi

cp -r "$root/template" "$dest"
echo "已创建 problems/$1"
