#!/bin/bash

# SESSION_NAME="scout-process"
SESSION_NAME="scout:processes"

PARAM="$1"

# GLOBPAY="$SESSION_NAME:globpay"
# SCOTT="$SESSION_NAME:scott"
# GAME_SERVER="$SESSION_NAME:game-server"
# GLOBPAY_JOBS="$SESSION_NAME:globpay-jobs"
# GAME_SERVER_RPC="$SESSION_NAME:game-server-rpc"
# FRONTEND="$SESSION_NAME:frontend"
#
#
GLOBPAY="$SESSION_NAME.1"
SCOTT="$SESSION_NAME.3"
GAME_SERVER="$SESSION_NAME.5"
GLOBPAY_JOBS="$SESSION_NAME.2"
GAME_SERVER_RPC="$SESSION_NAME.6"
FRONTEND="$SESSION_NAME.4"

TMUX_CMD="/opt/homebrew/bin/tmux send-keys -t"

send_ctrl_c() {
  $TMUX_CMD send-keys -t "$GLOBPAY" C-c
  $TMUX_CMD send-keys -t "$SCOTT" C-c
  $TMUX_CMD send-keys -t "$GAME_SERVER" C-c
  $TMUX_CMD send-keys -t "$GLOBPAY_JOBS" C-c
  $TMUX_CMD send-keys -t "$GAME_SERVER_RPC" C-c
  $TMUX_CMD send-keys -t "$FRONTEND" C-c
}

start() {
  $TMUX_CMD send-keys -t "$GLOBPAY" "nvm use 22.13" C-m
  $TMUX_CMD send-keys -t "$GLOBPAY" "yarn watch" C-m

  $TMUX_CMD send-keys -t "$SCOTT" "pnpm dev" C-m

  $TMUX_CMD send-keys -t "$GAME_SERVER" "nvm use 22.13" C-m
  $TMUX_CMD send-keys -t "$GAME_SERVER" "yarn dev" C-m

  $TMUX_CMD send-keys -t "$GLOBPAY_JOBS" "nvm use 22.13" C-m
  $TMUX_CMD send-keys -t "$GLOBPAY_JOBS" "yarn worker" C-m

  $TMUX_CMD send-keys -t "$GAME_SERVER_RPC" "nvm use 22.13" C-m
  $TMUX_CMD send-keys -t "$GAME_SERVER_RPC" "yarn rpc" C-m


  $TMUX_CMD send-keys -t "$FRONTEND" "npx turbo serve --filter=fanteam-client" C-m
}

change_db_env() {
  ENVIRONMENT="$1"

  # Map "stage" to "stg" for the frontend command
  if [ "$ENVIRONMENT" == "stage" ]; then
    MAPPED_ENVIRONMENT="stg"
  else
    MAPPED_ENVIRONMENT="$ENVIRONMENT"
  fi

  $TMUX_CMD send-keys -t "$GLOBPAY" "cp .env.${ENVIRONMENT} .env" C-m
  $TMUX_CMD send-keys -t "$SCOTT" "cp .env.${ENVIRONMENT} .env" C-m
  $TMUX_CMD send-keys -t "$GAME_SERVER" "cp ./src/config/${ENVIRONMENT}.development.js ./src/config/development.js" C-m

  $TMUX_CMD send-keys -t "$FRONTEND" "cp ./apps/fanteam-client/.ftwrc-${MAPPED_ENVIRONMENT} ./apps/fanteam-client/.ftwrc" C-m
}

case "$PARAM" in
    local)
        send_ctrl_c
        change_db_env "local"
        start
        ;;
    stage)
        send_ctrl_c
        change_db_env "stage"
        start
        ;;
    qa)
        send_ctrl_c
        change_db_env "qa"
        start
        ;;
    stop)
        send_ctrl_c
        ;;
    *)
        echo "Unsupported parameter: $PARAM. Please use 'stop', 'stage', 'qa', 'local'"
        ;;
esac


