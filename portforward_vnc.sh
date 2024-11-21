#!/bin/bash

# free_ports() {
#     PID_LIST=$(lsof -i :5900 | awk 'NR!=1 {print $2}')
    
#     if [ -z "$PID_LIST" ]; then
#         echo "No processes found using port 5900."
#     else
#         for PID in $PID_LIST; do
#             echo "Killing process with PID $PID"
#             kill $PID
#         done
#     fi
# }

free_ports() {
    # Define the ports you want to check
    PORTS=(5900 5901)

    # Loop through each port
    for PORT in "${PORTS[@]}"; do
        # Get the list of PIDs using the port
        PID_LIST=$(lsof -i :$PORT | awk 'NR!=1 {print $2}')
        
        if [ -z "$PID_LIST" ]; then
            echo "No processes found using port $PORT."
        else
            for PID in $PID_LIST; do
                echo "Killing process with PID $PID using port $PORT"
                kill $PID
            done
        fi
    done
}

free_ports
current_dir=$(pwd)
echo "Current directory: ${current_dir}"

pod=$(minikube kubectl -- get pods --no-headers -o custom-columns=':metadata.name' | grep -i deployment)
echo "Pod name: ${pod}"

status=""
counter=0

while [ "$status" != "Running" ] && [ $counter -lt 200 ]; do
    echo "Sleeping for 5 seconds..."
    sleep 5

    status=$(minikube kubectl -- get pods ${pod} --no-headers -o custom-columns=':status.phase')
    echo "Status: ${status}"
    ((counter++))
done


if [ "$status" != "Running" ]; then
    echo "Status is still not Running after 200 tries."
    exit 1
fi

minikube kubectl -- port-forward ${pod} 5900:5900 &
