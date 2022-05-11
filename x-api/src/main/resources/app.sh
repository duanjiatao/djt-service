#!/bin/bash

SCRIPT=$0
DEPLOY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR=$DEPLOY_DIR/config
SERVICE=${service.name}
JAR=${artifactId}-${version}.${packaging}
LOCATION=$DEPLOY_DIR/lib/$JAR

JAVA_OPTS="-server -Xms512m -Xmx1g -Xmn256m -verbose:gc -Xloggc:$DEPLOY_DIR/gc.log"
JAVA_OPTS="$JAVA_OPTS  -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC  -XX:+PrintGCDetails -XX:-OmitStackTraceInFastThrow"

CONF_LOG="-Dlogging.config=$CONF_DIR/log4j2.xml"
CONF_APP="--spring.config.location=$CONF_DIR/application.properties"

#使用说明，用来提示输入参数
usage() {
  echo "Usage: sh $SCRIPT [start|stop|restart|status]"
  exit 1
}

#检查程序是否在运行
is_exist() {
  PID=$(ps -ef | grep $SERVICE | grep -v grep | awk '{print $2}')
  #如果不存在返回1，存在返回0
  if [ -z "${PID}" ]; then
    return 1
  else
    return 0
  fi
}

#启动方法
start() {
  is_exist
  if [ $? -eq "0" ]; then
    echo "Application $SERVICE is already running PID=$PID"
  else
    echo "Starting application $SERVICE..."
    nohup java $JAVA_OPTS $CONF_LOG -jar $LOCATION $CONF_APP $SERVICE >/dev/null 2>&1 &
    PID=$(echo $!)
    echo "Application $SERVICE start success PID=$PID"
  fi
}

#停止方法
stop() {
  is_exist
  if [ $? -eq "0" ]; then
    kill -15 $PID
    local PID_TMP=$PID
    echo "Stopping application $SERVICE..."
    sleep 3s
  else
    echo "Application $SERVICE is not running."
    return 0
  fi

  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $PID
    echo "Application $SERVICE is killed PID=$PID"
  else
    echo "Application $SERVICE stop success PID=$PID_TMP"
  fi
}

#输出运行状态
status() {
  is_exist
  if [ $? -eq "0" ]; then
    echo "Application $SERVICE is running PID=$PID"
  else
    echo "Application $SERVICE is not running."
  fi
}

#重启
restart() {
  stop
  start
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
"start")
  start
  ;;
"stop")
  stop
  ;;
"status")
  status
  ;;
"restart")
  restart
  ;;
*)
  usage
  ;;
esac
