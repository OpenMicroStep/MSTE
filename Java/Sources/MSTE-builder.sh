#!/bin/sh

export TM_PROJECT_DIRECTORY=`pwd`
export PROJECT_NAME="mste"
export LIBRARY_FOLDER="/Library"
export JAVA_HOME="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"
export baseName="MSTE"

echo "Building project ${PROJECT_NAME} from folder ${TM_PROJECT_DIRECTORY} ..."

if [ ! -d "${TM_PROJECT_DIRECTORY}" ]; then echo "TM_PROJECT_DIRECTORY Folder '${TM_PROJECT_DIRECTORY}', does not exist, aborting." exit 10002; fi;
export SOURCE_CLASSES_DIRECTORY="${TM_PROJECT_DIRECTORY}/JavaMSTE"

# vefication de l'existence a la fois de la variable ${LIBRARY_FOLDER} et du dossier sur le disque 
if [ ! -d "${LIBRARY_FOLDER}" ]; then echo "FOLDER BIBLIOTHEQUE DE BASE Folder '${LIBRARY_FOLDER}', does not exist, aborting." exit 10001; fi;


export JAVA_BUILDS="${LIBRARY_FOLDER}/JavaDev/Builds" ;
if [ ! -d "${JAVA_BUILDS}" ]; then echo "JAVA_BUILDS Folder '${JAVA_BUILDS}', does not exist, aborting." exit 10003; fi;

# preparation de la generation
echo "Preparation des dossiers de build"
export BUILD_FOLDER="${JAVA_BUILDS}/${PROJECT_NAME}"
export TARGET_NAME="MSTE"
export BUILD_TARGET_FOLDER="${BUILD_FOLDER}/${TARGET_NAME}"
export BUILD_JAVA_FOLDER="${BUILD_TARGET_FOLDER}/Classes"

echo "Java Build Folder is ${BUILD_JAVA_FOLDER}  ..."

if [ ! -d "${BUILD_FOLDER}" ];   then mkdir "${BUILD_FOLDER}" || exit 10004 ; fi;
if [ -d "${BUILD_TARGET_FOLDER}" ];   then rm -r "${BUILD_TARGET_FOLDER}" || exit 10005 ; fi;
mkdir "${BUILD_TARGET_FOLDER}" || exit 10006 ;
chmod a+rwX "${BUILD_TARGET_FOLDER}" || exit 10007 ;
mkdir "${BUILD_JAVA_FOLDER}" || exit 10010 ;
chmod a+rwX "${BUILD_JAVA_FOLDER}" || exit 10011 ;
echo "done."


# constitution du class path
echo "Creation du class path..."
export JAR_FOLDER_NAME="Jars"
export JARS_FOLDER="${TM_PROJECT_DIRECTORY}/${JAR_FOLDER_NAME}"
export jars="`find $JARS_FOLDER -name \*.jar -print`" 
export CLASSPATH=":." ;
for f in ${jars}
do
	export CLASSPATH="$f:$CLASSPATH" ;
done
echo "done."

# Compilation
echo "Compilation ..."
cd $BUILD_JAVA_FOLDER

echo "Source classes directory ${JAVA_HOME} ..."
${JAVA_HOME}/bin/javac -Xlint:unchecked -encoding UTF8 -sourcepath $SOURCE_CLASSES_DIRECTORY -d "$BUILD_JAVA_FOLDER" ${SOURCE_CLASSES_DIRECTORY}/*.java || exit 10012
echo "done."
echo -n "    - Packaging tool ${baseName} ..."
echo "Main-Class: org.openmicrostep.mste.MSTETests" > $BUILD_JAVA_FOLDER/Manifest.txt
echo "" >> $BUILD_JAVA_FOLDER/Manifest.txt
jar cfm ../${baseName}.jar Manifest.txt org
echo "done."


