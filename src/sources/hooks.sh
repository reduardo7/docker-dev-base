before_run() {
  e
  e "Stop $(style bold)apache2"
  cmd_log "sudo service apache2 stop"
}

after_run() {
  e
  e "Start $(style bold)apache2"
  cmd_log "sudo service apache2 start"
}
