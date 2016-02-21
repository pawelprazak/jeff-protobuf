#!/usr/bin/env bash

# https://github.com/os72/protoc-jar

VERSION=2.6.1.4
PROTOC=protoc-jar-${VERSION}.jar

if [ ! -f ${PROTOC} ]; then
    echo "File ${PROTOC} not found. Downloading.."
    wget http://central.maven.org/maven2/com/github/os72/protoc-jar/${VERSION}/protoc-jar-${VERSION}.jar
fi

usage () {
    echo "protoc-jar usage:"
    java -jar ${PROTOC} --help
    exit 1;
}

SRC=src/main/protobuf/jeff/proto
OUT=out
OUT_JAVA=${OUT}/java
OUT_CPP=${OUT}/cpp
PROTOS=${SRC}/event.proto

clean () {
    echo "Cleaning the ${OUT} directory"
    rm -rf ${OUT}
}

for i in "$@"
do
case $i in
    --clean)
    clean;
    ;;
    -h|--help)
    usage;
    ;;
    *)
    echo "unknown option $i"
    echo
    usage;
    ;;
esac
done

if [ ! -d ${SRC}  ]; then
    echo "Directory ${SRC} not found"
    exit 1
fi

if [ ! -f ${OUT_JAVA}  ]; then
    echo "Creating ${OUT_JAVA} directory"
    mkdir -p ${OUT_JAVA}
fi

if [ ! -f ${OUT_CPP}  ]; then
    echo "Creating ${OUT_CPP} directory"
    mkdir -p ${OUT_CPP}
fi

java -jar ${PROTOC} -IPATH=${SRC} --cpp_out=${OUT_CPP} --java_out=${OUT_JAVA} ${PROTOS}

tree ${OUT}