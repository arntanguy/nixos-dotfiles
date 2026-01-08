#!/usr/bin/env bash
pid=$(niri msg focused-window | awk '/PID:/ {print $2}')
if [ -n "$pid" ]; then
    kill -9 "$pid"
fi
