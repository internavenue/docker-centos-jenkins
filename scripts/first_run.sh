pre_start_action() {
  mkdir -p $LIB_DIR
  mkdir -p $CACHE_DIR
  mkdir -p "$LOG_DIR/jenkins"
}

post_start_action() {
  rm /first_run
}
