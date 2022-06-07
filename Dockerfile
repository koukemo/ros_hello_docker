FROM ros:noetic

ENV DEBIAN_FRONTEND=noninteractive

# Install apt packages
RUN echo "-----Install apt packages-----"
RUN apt-get update -y && \
    apt-get install -y \
        vim \
        wget \
        unzip \
        git \
        build-essential \
        iproute2 \
        iputils-ping \
        net-tools

# ROS settings
RUN echo "-----ROS settings-----"
ENV PATH $PATH:/opt/ros/noetic/bin
## rosdep settings
RUN apt-get install python3-rosdep
RUN rosdep update
## ros tools
RUN apt-get install -y \
        python3-osrf-pycommon \
        python3-catkin-tools \
        ros-noetic-rosbridge-server

# ROS Workspace
RUN echo "-----ROS Workspace settings-----"
RUN mkdir -p /root/ros_ws/src
COPY hello_ros/ /root/ros_ws/src/hello_ros
RUN cd root/ros_ws && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash; catkin build"
RUN chmod +x /root/ros_ws/src/hello_ros/src/hello.py
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /root/ros_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "Setup is complete. ROS projects can start!" 

# Open port
EXPOSE 9090

# Start Directory
WORKDIR /root/ros_ws