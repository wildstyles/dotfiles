#!/usr/bin/env bash

APP_ID=$1
APP_NAME=$2
TARGET_WORKSPACE=$3

focus_app() {
  echo "$TARGET_WORKSPACE"
  app_window_id=$(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name}" | grep $APP_NAME | cut -d' ' -f1 | sed '1p;d')
  aerospace focus --window-id $app_window_id --fail-if-noop
  aerospace move-node-to-workspace $TARGET_WORKSPACE --fail-if-noop
  aerospace workspace $TARGET_WORKSPACE --fail-if-noop
  aerospace move-mouse window-lazy-center --fail-if-noop
}

app_closed() {
  if [ "$(aerospace list-windows --all --format '%{app-name}' | grep $APP_NAME)" == "" ]; then
    true
  else
    false
  fi
}

app_focused() {
  if [ "$(aerospace list-windows --focused --format "%{app-bundle-id}")" == "$APP_ID" ]; then
    true
  else
    false
  fi
}

unfocus_app() {
  aerospace move-node-to-workspace 1
}

if app_closed; then
  open -a $APP_NAME
  sleep 0.5
  focus_app
else
  if app_focused; then
    unfocus_app
  else
    focus_app
  fi
fi
