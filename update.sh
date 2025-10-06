#!/bin/bash
# This script is used to manually fetch blueprints from remote

LOG_PATH="update.log"
REMOTE_URI="git@github.com:DSPBluePrints/FactoryBluePrints.git"

cd "$(dirname "$0")"

# debug info
ls > $LOG_PATH
echo "----" >> $LOG_PATH

# test dir
if [ ! -d "../../Blueprint" ]; then
    echo "$(date '+%x %X') Warning: Abnormal installation path" >> "$LOG_PATH"
    echo "警告：您似乎安装到了错误的路径，这可能导致文件权限异常"
fi

# test git
# git should already be installed as a package
if git --version &> /dev/null; then
    echo "$(date '+%x %X') Infomation: GIT_PATH=$(command -v git)"
else
    echo "错误：无法找到git"
    echo "$(date '+%x %X') Error: git not found" >> "$LOG_PATH"
    exit 1
fi

# find .git
if [ ! -d ".git" ]; then
    echo "警告：无法找到.git"
    echo "$(date '+%x %X') Warning: .git not found" >> "$LOG_PATH"
    git init
    git remote add origin $REMOTE_URI
fi

# force-reset
git remote set-url origin $REMOTE_URI
git fetch --all
git reset --hard origin/main
echo "$(date '+%x %X') Information : git reset --hard" >> "$LOG_PATH"
# git clean -fd
