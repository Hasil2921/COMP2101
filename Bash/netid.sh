#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name
#         If the user includes the option -v on the command line, set the varaible $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a for loop to generate the report for every interface except loopback

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed
function usage {
cat <<EOF
Usage: $0 [Interface name] [-v|--verbose ] [-h|--help]
Not providing any command line options will result in printing all available interfaces in the system
EOF
}
function fullinfointerface {
count=$(lshw -class network | awk '/logical name:/{print $3}' | wc -l)
for((w=1;w<=$count;w+=1));
do
  interface=$(lshw -class network |
    awk '/logical name:/{print $3}' |
      awk -v z=$w 'NR==z{print $1; exit}')
  if [[ $interface = lo* ]] ; then continue ; fi
  [ "$verbose" = 1 ] && echo "Getting ipv4 address of $interface"
  ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
  [ "$verbose" = 1 ] && echo "Getting $ipv4_address 's hostname of interface $interface"
  ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
  [ "$verbose" = 1 ] && echo "Getting network address of $interface"
  network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
  [ "$verbose" = 1 ] && echo "Getting network number of $interface"
  network_number=$(cut -d / -f 1 <<<"$network_address")
  [ "$verbose" = 1 ] && echo "Getting network name of $interface"
  network_name=$(getent networks $network_number|awk '{print $1}')
  [ "$verbose" = 1 ] && echo "Printing final report of interface $interface"
  echo Interface $interface:
  echo ===============
  echo Address         : $ipv4_address
  echo Name            : $ipv4_hostname
  echo Network Address : $network_address
  echo Network Name    : $network_name
done
}
function singleinterface {
  interface=$interfacenamesingle
  if [[ $interface = lo* ]] ; then continue ; fi
  [ "$verbose" = 1 ] && echo "Getting ipv4 address of $interface"
  ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
  [ "$verbose" = 1 ] && echo "Getting $ipv4_address 's hostname of interface $interface"
  ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
  [ "$verbose" = 1 ] && echo "Getting network address of $interface"
  network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
  [ "$verbose" = 1 ] && echo "Getting network number of $interface"
  network_number=$(cut -d / -f 1 <<<"$network_address")
  [ "$verbose" = 1 ] && echo "Getting network name of $interface"
  network_name=$(getent networks $network_number|awk '{print $1}')
  [ "$verbose" = 1 ] && echo "Printing final report of interface $interface"
  echo Interface $interface:
  echo ===============
  echo Address         : $ipv4_address
  echo Name            : $ipv4_hostname
  echo Network Address : $network_address
  echo Network Name    : $network_name
}

while [ $# -gt 0 ]; do
case $1 in
-v | --verbose )
	verbose=1
	shift
	;;
-h | --help )
	usage
   	exit 0
  	;;
*)
    interfacenamesingle=$1
;;
esac
shift
if [ $verbose = 1 ]; then
  echo "Varbose mode is On."
else
  echo "Varbose mode is Off."
fi
done
# Per-information gathering
#####
[ "$verbose" = 1 ] && echo "Gathering host information"
myhostname=$(hostname)
[ "$verbose" = 1 ] && echo "Identifying default route"
router_address=$(ip r s default| cut -d ' ' -f 3)
router_hostname=$(getent hosts $default_router_address|awk '{print $2}')
[ "$verbose" = 1 ] && echo "Checking for external IP address and hostname"
external_ip=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_ip | awk '{print $2}')
#####
# End of per-information gathering
#####
#####
# Once per host report
#####

if [ -z "$interfacenamesingle" ]
then
	usage
	fullinfointerface
else
      singleinterface
fi
#####
# End of Once per host report
#####
