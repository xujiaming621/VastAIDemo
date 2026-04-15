#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$SCRIPT_DIR/server.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PID_FILE"
        echo "[停止] 服务已停止 (PID=$PID)"
    else
        echo "[提示] 进程不存在，清理 PID 文件"
        rm -f "$PID_FILE"
    fi
else
    echo "[提示] 未找到 server.pid，尝试按进程名查找..."
    pkill -f "node server.js" && echo "[停止] 已停止" || echo "[提示] 未找到运行中的服务"
fi
