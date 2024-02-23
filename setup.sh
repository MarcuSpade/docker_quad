#!/bin/bash
cd /home/ubuntu/quad_ws/src/robots
./install_descriptions
# Inicializar o rosdep
rosdep init --rosdistro noetic

# Atualizar rosdep
rosdep update

# Navegar até o diretório do workspace
cd /home/ubuntu/quad_ws

# Instalar as dependências do ROS
rosdep install --from-paths src --ignore-src -r -y