alias cpuusage='sar -u 1 3'
alias loadaverage='sar -q 1 3'
alias memorystatas='sar -r 1 3'
alias iowaitpercent='sar -f'
alias swapstatus='sar -W'

# user: cpuusage of usermode
# nice: cpuusage of usermode of process schedule nice
# system: cpuusage of system
# iowait: cpu idle percentage for disk io
# steal: idle percentage for calculate virtual cpu
# idle: cpu idle percentage except for disk io
#
# kbmemfree: free of physic memory
# kbmemuserd: used of physic memory
# memused: (percentage) above
# kbbuffers: amount of physic memory of kernel buffer
# kbcached: amount of physic memory of kernel cache buffer
# kbswpfree: free amount of swap
# kbswpued: amount of swap used

