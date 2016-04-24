before_run() {
  e
  e "Stop $(style bold)Apache2"
  cmd_log "sudo service apache2 stop"
}

after_run() {
  e
  e "Start $(style bold)Apache2"
  cmd_log "sudo service apache2 start"
}
