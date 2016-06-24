HOOKS.before-run() {
  @e
  @e "Stop $(@style bold)Apache2"
  @cmd-log "sudo service apache2 stop"
}

HOOKS.after-run() {
  @e
  @e "Start $(@style bold)Apache2"
  @cmd-log "sudo service apache2 start"
}
