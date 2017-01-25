HOOKS.before-run() {
  @print
  @print "Stop $(@style bold)Apache2"
  @cmd-log "sudo service apache2 stop"
}

HOOKS.after-run() {
  @print
  @print "Start $(@style bold)Apache2"
  @cmd-log "sudo service apache2 start"
}
