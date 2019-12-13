################################################################################
#!/bin/bash
#
# \author:  Marco Israel
# \date:    Dezember 2019
#
# \brief:   Script to build a docker command script as also starting docker 
# \detail:  
#           Setup a script which is called out of the docker container
#           which holds all commands which should be executed by the image.
#          
#           Afterwards this script starts the docker image.
#
#
#           USAGE: dockerrun.sh [ [-t <image_version] [-h] ]    \ 
#                   <tool> <command> [-t <image_version>]" 
#
#
################################################################################



TASK="yocto"
VERSION="16.04"
NAME_YOCTOIMAGE="phytec-headless-image"
FILE_POKYSCRIPT="./meta-layers/poky/oe-init-build-env" 
FILE_DOCKEJOBS="dockerjob.sh"
CMD=""


if ( ! ps ax | grep -v grep | grep docker > /dev/null )
then
    sudo systemctl start docker
fi



# Set the docker image version 
while getopts t:i:h: option
do
    case "${option}"
        in
        t) VERSION="${OPTARG}"
            ;;
        i) NAME_YOCTOIMAGE="${OPTARG}"
            ;;
        h)  echo "USAGE:"
            echo "$0 [ [-t <image_version>] [-h] ]
            <too> <command> [-t <image_version>]"
            ;;
        c) CMD="${OPTARG}"
            ;;
    esac
done


#Shift away the getopts parameters 
shift $((OPTIND-1))

#make the imagename aviable in the shell
export I=$NAME_YOCTOIMAGE


#build the docker run script

if ( [ $# -gt 0 ] )
then
    echo "#/bin/bash" > $FILE_DOCKEJOBS
    echo "" >> $FILE_DOCKEJOBS
    echo "#Commands to run inside the docker container after startup"       \
        >> $FILE_DOCKEJOBS
    echo "" >> $FILE_DOCKEJOBS

    echo "#Define the location whre to find the template files (*.sample)"   \
    >> $FILE_DOCKEJOBS

    echo 'TEMPLATECONF=$PWD/tools/templateconf' >> $FILE_DOCKEJOBS

    echo "" >> $FILE_DOCKEJOBS
    echo "#Setup /prepare the current working shell " >> $FILE_DOCKEJOBS
    echo "source $FILE_POKYSCRIPT $NAME_YOCTOIMAGE" >> $FILE_DOCKEJOBS

    echo "" >> $FILE_DOCKEJOBS
    echo "#Run the following commands below in a batch mode" >> $FILE_DOCKEJOBS
    echo "$*" >> $FILE_DOCKEJOBS
fi



#start the docker container now

echo "############################################################"
echo ""
echo "Starting docker container         $TASK:$VERSION"
echo ""
echo "############################################################"

docker run --name $TASK -it --rm -v $PWD:/$TASK $TASK:$VERSION $CMD



################################################################################
########## EOF #################################################################


