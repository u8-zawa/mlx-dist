#!/usr/bin/env bash
set -e

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# プロジェクトのパスと環境名の設定
PROJECT_PATH=$PWD
PYTHON_VERSION="3.12"
VENV_PATH="$PROJECT_PATH/.venv"

# uvのインストールを確認
if ! command -v uv &> /dev/null; then
    echo "ERROR: uv is not installed."
fi

# 既存の仮想環境を削除
log "Removing existing virtual environment ..."
rm -f pyproject.toml .python-version uv.lock
rm -rf "$VENV_PATH"

# uvを使用してPython環境をセットアップ
log "Setting up Python environment with uv ..."
uv init --python "$PYTHON_VERSION"
rm -f README.md main.py

# MLX, OpenMPIのインストール
log "Installing MLX and OpenMPI ..."
uv add mlx-lm openmpi

# pipeline_generate.pyのダウンロード
log "Downloading pipeline_generate.py ..."
curl -O https://raw.githubusercontent.com/ml-explore/mlx-lm/refs/heads/main/mlx_lm/examples/pipeline_generate.py
