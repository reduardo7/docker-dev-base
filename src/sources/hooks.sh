_fix_perm() {
  e "Fix permissions $DOCKDEV_PROJECTS/*"
  sudo chmod a+w $DOCKDEV_PROJECTS/*
}

before_run() {
  e
  e "Stop $(style bold)apache2"
  cmd_log "sudo service apache2 stop"
  _fix_perm
}

after_run() {
  e
  e "Start $(style bold)apache2"
  cmd_log "sudo service apache2 start"
  _fix_perm
}
