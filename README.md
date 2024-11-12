# Docker for CHVMP Repositories

This Docker image is set up to run the CHVMP repositories efficiently within a container.

## Instructions

### Locate the Docker Folder

Navigate to the Docker folder within your workspace. Make sure to replace `<...>` placeholders with your specific directory paths.

    cd <path_to_workspace>/docker_quad/

### Build the Docker Image

Within the Docker folder, execute the following command to build the Docker image:

    docker build -t quad-image .
    
### Run the Docker Container

After building the image, run the container using `run.sh`. 

    ./run.sh

Make sure to check the shared folder path in line 39 of run.sh.

In `run.sh`:

    -v <path_to_workspace>:/home/ubuntu/modbot_ws \

This line specifies a shared volume between your host machine and the Docker container. If you want to use a different workspace, replace `<...>` placeholders with your specific directory paths. Alternatively, you can remove this line if you do not need a shared volume.
Additional Notes

