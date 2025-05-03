#!/usr/bin/env bash

# 総メモリ容量をMB単位で取得
TOTAL_MEM_MB=$(($(sysctl -n hw.memsize) / 1024 / 1024))

# 総メモリの80%と(総メモリ-5GB)をMB単位で計算
EIGHTY_PERCENT=$(($TOTAL_MEM_MB * 80 / 100))
MINUS_5GB=$((($TOTAL_MEM_MB - 5120)))

# 総メモリの70%と(総メモリ-8GB)をMB単位で計算
SEVENTY_PERCENT=$(($TOTAL_MEM_MB * 70 / 100))
MINUS_8GB=$((($TOTAL_MEM_MB - 8192)))

# WIRED_LIMIT_MBに大きい方の値を設定
if [ $EIGHTY_PERCENT -gt $MINUS_5GB ]; then
  WIRED_LIMIT_MB=$EIGHTY_PERCENT
else
  WIRED_LIMIT_MB=$MINUS_5GB
fi

# WIRED_LWM_MBに大きい方の値を設定
if [ $SEVENTY_PERCENT -gt $MINUS_8GB ]; then
  WIRED_LWM_MB=$SEVENTY_PERCENT
else
  WIRED_LWM_MB=$MINUS_8GB
fi

# 計算された値を表示
echo "Total memory: $TOTAL_MEM_MB MB"
echo "Maximum limit (iogpu.wired_limit_mb): $WIRED_LIMIT_MB MB"
echo "Lower bound (iogpu.wired_lwm_mb): $WIRED_LWM_MB MB"

# sysctlで値を適用（既にroot権限かどうかを確認）
if [ "$EUID" -eq 0 ]; then
  sysctl -w iogpu.wired_limit_mb=$WIRED_LIMIT_MB
  sysctl -w iogpu.wired_lwm_mb=$WIRED_LWM_MB
else
  # 最初にsudo無しで試行し、必要な場合はsudoを使用
  sysctl -w iogpu.wired_limit_mb=$WIRED_LIMIT_MB 2>/dev/null || \
    sudo sysctl -w iogpu.wired_limit_mb=$WIRED_LIMIT_MB
  sysctl -w iogpu.wired_lwm_mb=$WIRED_LWM_MB 2>/dev/null || \
    sudo sysctl -w iogpu.wired_lwm_mb=$WIRED_LWM_MB
fi