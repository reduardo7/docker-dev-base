_fix_perm() {
  echo > $DEV_NULL
  #e "Fix permissions $DOCKDEV_MOUNTS_FAKEMAIL"
  #sudo chmod -R a+w $DOCKDEV_MOUNTS_FAKEMAIL
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
