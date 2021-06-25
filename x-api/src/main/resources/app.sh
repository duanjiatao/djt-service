#!/bin/bash

SCRIPT=$0
DEPLOY_DIR=$(pwd)
CONF_DIR=$DEPLOY_DIR/config
JAR_NAME=${artifactId}-${version}.${packaging}
LOCATION=$DEPLOY_DIR/lib/${JAR_NAME}

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
  PID=$(ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}')
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
    echo "Application $JAR_NAME is already running. PID=$PID"
  else
    echo "Starting application..."
    nohup java $JAVA_OPTS $CONF_LOG -jar $LOCATION $CONF_APP >/dev/null 2>&1 &
    PID=$(echo $!)
    echo "Application $JAR_NAME start success. PID=$PID"
  fi
}

#停止方法
stop() {
  is_exist
  if [ $? -eq "0" ]; then
    kill -15 $PID
    echo "Application $JAR_NAME process stop. PID=$PID"
    sleep 3s
  else
    echo "Application $JAR_NAME is not running."
    return 0
  fi

  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $PID
    echo "Application $JAR_NAME process is killed. PID=$PID"
  else
    echo "Application $JAR_NAME process stop success."
  fi
}

#输出运行状态
status() {
  is_exist
  if [ $? -eq "0" ]; then
    echo "Application $JAR_NAME is running. PID=$PID"
  else
    echo "Application $JAR_NAME is not running."
  fi
}

#重启
restart() {
  stop
  sleep 1s
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
