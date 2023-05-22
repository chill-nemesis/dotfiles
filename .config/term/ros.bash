# source the ROS environment

TC_ROS_PATH="/opt/ros/melodic/setup.bash"

if [[ -f $TC_ROS_PATH ]]; then 
	DebugMessage "Loading ROS environment at: " $TC_ROS_PATH
	source $TC_ROS_PATH
else
	DebugMessage "Could not load ROS environment at: " $TC_ROS_PATH
fi

unset TC_ROS_PATH
