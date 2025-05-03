#!/usr/bin/env bash
set -e

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Open MPIにTCP接続用のen0インターフェースを使用するよう指示
export OMPI_MCA_btl_tcp_if_include=en0

log "Running distributed MLX job ..."

uv run mlx.launch \
  --hostfile "$PROJECT_PATH/hosts.json" \
  --backend mpi \
  "$PROJECT_PATH/pipeline_generate.py" \
  --prompt "What number is larger 6.9 or 6.11?" \
  --max-tokens 128 \
  --model mlx-community/DeepSeek-Coder-V2-Lite-Instruct-4bit-mlx

log "MLX run complete!"