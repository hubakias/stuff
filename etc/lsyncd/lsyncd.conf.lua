settings = {
    logfile = "/var/log/lsyncd/lsyncd.log",
    statusFile = "/var/log/lsyncd/lsyncd.status"
}

sync {
    default.rsyncssh,
    source="/mylocaldir/",
    host="myremote_host",
    targetdir="/myremotedir",
--    rsyncOpts = {"-e", "/usr/bin/ssh -l myremoteuser -i myremoteuser_priv_key -p my_remote_ssh_port"}
}
