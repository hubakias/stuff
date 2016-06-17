# The ssh "timed out waiting for input: auto-logout" messages is generated by
# ssh upon reaching a auto-logout after an inactivity time specified by the
# TMOUT environment variable. If this variable is not set your session will not
# be auto-logged out due to inactivity. If the environment variable is set, your
# session will be automatically closed/logged out after the amount of seconds
# specified by the TMOUT variable.

TMOUT=3600
readonly TMOUT
export TMOUT
