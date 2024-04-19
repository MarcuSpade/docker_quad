Docker built to run the Chvmp repositories.

## Instructions

Find the docker folder
Do not forget to change <...> parts

cd <directory_to_ws>/docker_quad/

Run the docker build in te Dockerfile folder

docker build -it quad-image .

After that, execute the run.sh

It's important to remember in the run.sh 39 line, we have a share folder with the docker container
    
  ###  -v /home/marcus/modbot_ws:/home/ubuntu/modbot_ws \

If you want delete this line or you can put you workspace folder to share with the docker.