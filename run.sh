#!/usr/bin/env bash
export CONTAINER_IMAGE="quad-image"
export CONTAINER_NAME="quad_container"
export WITH_NVIDIA="ON"
export DISABLE_X="1"

# check for container image
if [ -z "$CONTAINER_IMAGE" ]; then
	echo 'ERROR:  the container image to run must be set with the --container or -c options'
fi

# check for display
DISPLAY_DEVICE=""

if [ -n "$DISPLAY" ]; then
	# give docker root user X11 permissions
	sudo xhost +si:localuser:root
	
	# enable SSH X11 forwarding inside container (https://stackoverflow.com/q/48235040)
	XAUTH=/tmp/.docker.xauth
	xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
	chmod 777 $XAUTH

	DISPLAY_DEVICE="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH"
fi

# print_var "CONTAINER_IMAGE"
# print_var "DISPLAY_DEVICE"
echo $PWD
# run the container
# for ros comunication Issue: https://github.com/eProsima/Fast-DDS/issues/1698
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)"]; then
    if [ ! "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
        echo "Create docker"
        docker create -it \
            --name $CONTAINER_NAME \
            --network host \
            -v /dev/dri:/dev/dri \
            -v /home/marcus/modbot_ws:/home/ubuntu/modbot_ws \
			-v /dev/shm:/dev/shm \
            -p 7414:7414/udp -p 7415:7415/udp \
            $DISPLAY_DEVICE \
            $CONTAINER_IMAGE
    fi
    docker start -ai $CONTAINER_NAME
else
    docker exec -ti $CONTAINER_NAME /bin/bash
fi
