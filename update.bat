@echo off
cd "%~dp0"

::变量
set WARNING_TEST_DIR=0

::debug info
set LOG_PATH=.\update.log
dir>%LOG_PATH%
echo ---->>%LOG_PATH%

::test dir
cd ..
cd ..
if not exist "Blueprint" (
set WARNING_TEST_DIR=1
echo %date% %time% Warning: Abnormal installation path>>%LOG_PATH%
echo 警告：您似乎安装到了错误的路径，这可能导致文件权限异常
)
cd "%~dp0"

::find git.exe
if exist ".\MinGit\cmd\git.exe" (
set GIT_PATH=.\MinGit\cmd\git.exe
echo %date% %time% Infomation: GIT_PATH=.\MinGit\cmd\git.exe>>%LOG_PATH%
) else (
set GIT_PATH=git
echo %date% %time% Infomation: GIT_PATH=git>>%LOG_PATH%
)

::test git.exe
%GIT_PATH% -v
if %errorlevel% NEQ 0 (
echo 错误：无法找到git.exe
echo %date% %time% Error: git.exe no found>>%LOG_PATH%
goto end_with_error
)

::find .git/
if not exist ".git" (
echo 错误：无法找到.git/
echo %date% %time% Error: .git/ no found>>%LOG_PATH%
goto end_with_error
)

::test .git/
%GIT_PATH% rev-parse --path-format=absolute --git-dir
if %errorlevel% NEQ 0 (
if %WARNING_TEST_DIR% NEQ 0 (
echo 错误：文件权限异常。这通常是因为git无权读写整个蓝图文件夹。
echo 请在解压蓝图仓库后，连同外面的文件夹一起放入，而不是将压缩包中的文件直接解压进蓝图文件夹。
echo %date% %time% Error: .git/ is broken>>%LOG_PATH%
goto end_with_error
)
echo 错误：.git/已损坏
echo %date% %time% Error: .git/ is broken>>%LOG_PATH%
goto end_with_error
)

::config
%GIT_PATH% config --local core.quotepath false
%GIT_PATH% config --local http.sslVerify false

::init
if not exist ".\.gitignore" (
%GIT_PATH% reset --hard
echo %date% %time% Infomation: %GIT_PATH% reset --hard>>%LOG_PATH%
)

::update
%GIT_PATH% pull origin main
if %errorlevel% NEQ 0 (
echo 错误：更新获取失败。这通常是网络波动，重试就行，无效请使用加速器/挂梯子后再更新。
echo %date% %time% Error: %GIT_PATH% pull origin main>>%LOG_PATH%
goto end_with_error
) else (
echo %date% %time% Infomation: %GIT_PATH% pull origin main>>%LOG_PATH%
)

:end
echo 蓝图文件更新完成，现在可以直接关闭此窗口
echo %date% %time% Infomation: Exit>>%LOG_PATH%
pause
exit

:end_with_error
echo 更新因为出现错误而中止，蓝图文件没有发生任何变动
echo 常见问题请阅读说明https://github.com/DSPBluePrints/FactoryBluePrints/blob/main/README.md
echo 如果仍然存疑可以加qq群反馈：936739864。请附上此页面截图和update.log截图。
echo %date% %time% Infomation: Exit>>%LOG_PATH%
pause
exit
