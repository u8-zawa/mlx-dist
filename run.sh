#!/usr/bin/env bash
set -e

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Open MPIにTCP接続用のen0インターフェースを使用するよう指示
export OMPI_MCA_btl_tcp_if_include=en0

log "Running distributed MLX job ..."

uv run mlx.launch \
  --hostfile "$PWD/hosts.json" \
  --backend mpi \
  "$PWD/pipeline_generate.py" \
  --prompt "hello" \
  --temperature 0.0 \
  --max-tokens 1024 \
  --model mlx-community/Qwen3-0.6B-4bit

log "MLX run complete!"