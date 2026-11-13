#!/bin/bash
set -e
. set_devkit_path.sh

if [[ -n "$JAVA_HOME" && -x "$JAVA_HOME/bin/javac" ]]; then
  echo "Using the preinstalled JDK at $JAVA_HOME"
  exit 0
fi

wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-10*.tar.gz
