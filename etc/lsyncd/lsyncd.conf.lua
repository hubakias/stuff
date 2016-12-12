settings = {
    logfile = "/var/log/lsyncd/lsyncd.log",
--    pidfile = "/var/run/lsyncd.pid",
--    nodaemon = "true",
    statusFile = "/var/log/lsyncd/lsyncd.status"
}

sync {
    default.rsyncssh,
    source = "/mylocaldir/",
    host = "myremote_host",
    targetdir = "/myremotedir",
--    delete = "true,false,startup,running",
--    exclude = { '.bak' , '.tmp' },
--    excludeFrom = "/etc/lsyncd/exclusions",
--    rsyncOpts = {"-e", "/usr/bin/ssh -l myremoteuser -i myremoteuser_priv_key -p my_remote_ssh_port"},
    ssh = {
      port = 1234
    }
}
