chcp 65001
@echo off

set LOG_PATH=.\update.log

dir>%LOG_PATH%

echo ---->>%LOG_PATH%

echo INF: %date% %time% Start>>%LOG_PATH%

::find git
if exist ".\MinGit\cmd\git.exe" (
set GIT_PATH=.\MinGit\cmd\git.exe
echo INF: %date% %time% GIT_PATH=.\MinGit\cmd\git.exe>>%LOG_PATH%
) else if exist "C:\Program Files\Git" (
set GIT_PATH=git
echo INF: %date% %time% GIT_PATH=git>>%LOG_PATH%
) else (
echo 警告：无法找到Git或MinGit。如果更新能正常进行请忽略 | Warning: Could not find Git or MinGit. Please ignore if the update works normally
echo WAR: %date% %time% Git/MinGit no found>>%LOG_PATH%
set GIT_PATH=git
)

::init
if not exist ".\.gitignore" (
%GIT_PATH% reset --hard
)

::update
echo INF: %date% %time% git pull start>>%LOG_PATH%
git config core.longpaths true
set GIT_SSL_NO_VERIFY=true
%GIT_PATH% pull origin main
if %errorlevel% NEQ 0 (
echo ERR: %date% %time% git pull error>>%LOG_PATH%
echo 错误：更新失败，这通常是网络问题。请重试，或者开加速器再更新。详见"README.md"
) else (
echo INF: %date% %time% git pull successed>>%LOG_PATH%
)

::end
echo INF: %date% %time% Exit>>%LOG_PATH%
pause
exit
