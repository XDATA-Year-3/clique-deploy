hostip=`netstat -rn | grep '^0.0.0.0' | awk '{print $2}'`
cat <<EOF
{
    "host": "${hostip}",
    "database": "clique",
    "collection": "anb"
}
EOF
