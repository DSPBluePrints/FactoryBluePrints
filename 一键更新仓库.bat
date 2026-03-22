@echo off

SETLOCAL enableextensions enabledelayedexpansion
chcp 65001 >NUL

REM 检查参数，如果不为空则只运行特定函数
IF "x%1" == "x" GOTO START
CALL :%1

ENDLOCAL
EXIT /b %errorlevel%


:START

REM 本地目录，如果当前目录有.git文件夹的存在，则不使用此目录
SET LocalFolder=FactoryBluePrints

REM 仓库地址
SET RepoUrl=https://github.com/DSPBluePrints/FactoryBluePrints.git

REM 仓库README地址
SET READMEUrl=https://github.com/DSPBluePrints/FactoryBluePrints/blob/main/README.md

REM MinGit安装位置
SET MinGitFolder=%ALLUSERSPROFILE%\MinGit

REM MinGit版本号
SET MinGitVersion=2.52.0

CALL :SETUP_MINGIT
IF %errorlevel% NEQ 0 (
  GOTO EOF
)

CALL :CLONE_REPO
IF %errorlevel% == 1 (
  GOTO EOF
)
IF %errorlevel% == -1 (
  GOTO END
)
IF %errorlevel% NEQ 0 (
  GOTO END_WITH_ERROR
)

CALL :UPDATE_REPO
IF %errorlevel% == 1 (
  GOTO EOF
)
IF %errorlevel% NEQ 0 (
  GOTO END_WITH_ERROR
)


:END

if NOT [%GIT_PATH%]==[] "%GIT_PATH%" config --global --unset-all safe.directory "\*"
ENDLOCAL
ECHO [92m 按任意键关闭此窗口...[0m
PAUSE >NUL
EXIT /b 0


:END_WITH_ERROR

ECHO [91m运行过程因为出现错误而中止，蓝图文件没有发生任何变动。[0m
ECHO [91m常见问题请阅读说明：%READMEUrl%。[0m


:EOF

ENDLOCAL
ECHO [92m 按任意键关闭此窗口...[0m
PAUSE >NUL
EXIT /b 1


REM ==================== Steps ====================

:SETUP_MINGIT

REM 查找系统可用的Git，如果没有就安装MinGit

REM 检查Git是否安装
git --version >NUL 2>&1 && (SET hasGit=1) || (SET hasGit=0)
IF %hasGit% NEQ 0 (
  SET GIT_PATH=git
  EXIT /b 0
)
"%GIT_INSTALL_ROOT%\bin\git" --version >NUL 2>&1 && (SET hasGit=1) || (SET hasGit=0)
IF %hasGit% NEQ 0 (
  SET GIT_PATH=%GIT_INSTALL_ROOT%\bin\git
  EXIT /b 0
)
"%CD%\MinGit\cmd\git" --version >NUL 2>&1 && (SET hasGit=1) || (SET hasGit=0)
IF %hasGit% NEQ 0 (
  SET GIT_PATH=%CD%\MinGit\cmd\git
  EXIT /b 0
)
"%MinGitFolder%\cmd\git" --version >NUL 2>&1 && (SET hasGit=1) || (SET hasGit=0)
IF %hasGit% NEQ 0 (
  SET GIT_PATH=%MinGitFolder%\cmd\git
  EXIT /b 0
)


:INSTALL_MINGIT

REM 安装MinGit
ECHO [1m^>^> 系统内未找到已经安装的Git，将下载MinGit并安装到%MinGitFolder%。[0m
ECHO [1m^>^> 如果以后不再需要可以手动删除这个目录。[0m
ECHO [1m^>^> 请选择下载方式：[0m
ECHO [1m     0. [36m从GitHub原始地址下载 (直接回车默认选择此方式)[0m
ECHO [1m     1. [36m使用ghfast.top代理[0m
ECHO [1m     2. [36m使用gh-proxy.org代理[0m
ECHO [1m     3. [36m使用gh.ddlc.top代理[0m
ECHO [1m     4. [36m使用www.ytools.cc/gh代理[0m
ECHO [1m     5. [36m使用git.yylx.win代理[0m
ECHO [1m     6. [36m使用ghfile.geekertao.top代理[0m
ECHO [1m     7. [36m使用ghm.078465.xyz代理[0m
ECHO [1m     8. [36m使用gitproxy.127731.xyz代理[0m
ECHO [1m     9. [36m使用jiashu.1win.eu.org代理[0m
ECHO [1m    10. [36m使用github.tbedu.top代理[0m
ECHO [1m     Q. [36m我不要下载了，我要退出[0m


:INSTALL_MINGIT_INPUT

SET /p res=[1m^>^> 请输入：[0m
SET GHPROXY=
IF /i "x%res%"=="x" (
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="0" (
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="1" (
  SET GHPROXY=ghfast.top/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="2" (
  SET GHPROXY=gh-proxy.org/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="3" (
  SET GHPROXY=gh.ddlc.top/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="4" (
  SET GHPROXY=www.ytools.cc/gh/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="5" (
  SET GHPROXY=git.yylx.win/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="6" (
  SET GHPROXY=ghfile.geekertao.top/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="7" (
  SET GHPROXY=ghm.078465.xyz/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="8" (
  SET GHPROXY=gitproxy.127731.xyz/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="9" (
  SET GHPROXY=jiashu.1win.eu.org/https://
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)
IF /i "%res%"=="10" (
  SET GHPROXY=github.tbedu.top/
  GOTO INSTALL_MINGIT_GHPROXY_WAS_SET
)

IF /i "%res%"=="Q" (
  ECHO [96m-- 已取消MinGit下载。[0m
  EXIT /b 1
)
ECHO [91m 输入有误。[0m
GOTO INSTALL_MINGIT_INPUT


:INSTALL_MINGIT_GHPROXY_WAS_SET

SET MinGitUrl=https://%GHPROXY%github.com/git-for-windows/git/releases/download/v%MinGitVersion%.windows.1/MinGit-%MinGitVersion%-64-bit.zip

rmdir /s /q %MinGitFolder% 1>NUL 2>NUL
mkdir %MinGitFolder% 2>NUL

ECHO | set /p=[96m-- 正在下载MinGit...[0m
powershell -Command "(New-Object Net.WebClient).DownloadFile('%MinGitUrl%', '%MinGitFolder%\MinGit.zip')"
IF %errorlevel% NEQ 0 (
  ECHO [91m 错误！[0m
  ECHO [91m!! MinGit下载失败，请检查你的网络，或使用加速器/挂梯子后再次运行。[0m
  EXIT /b 1
)
ECHO [96m 完成[0m

ECHO | set /p=[96m-- 正在解压MinGit...[0m
powershell -Command "(New-Object -Com Shell.Application).NameSpace('%MinGitFolder%').CopyHere((new-object -com shell.application).NameSpace('%MinGitFolder%\MinGit.zip').Items(), 1556)"
DEL /f /q %MinGitFolder%\MinGit.zip
IF %errorlevel% NEQ 0 (
  ECHO [91m 错误！[0m
  ECHO [91m!! MinGit解压失败，可能是网络问题导致下载的文件不完整。[0m
  EXIT /b 1
)
ECHO [96m 完成[0m
SET GIT_PATH=%MinGitFolder%\cmd\git
EXIT /b %errorlevel%


:SETUP_MIRROR

REM 设置仓库镜像或代理

ECHO [1m^>^> 请选择仓库镜像或代理：[0m
ECHO [1m     0. [36mGitHub (将删除已设置的镜像)[0m
ECHO [1m     1. [36m使用Bitbucket[0m
ECHO [1m     2. [36m使用Codeberg[0m
ECHO [1m    10. [36m使用ghfast.top代理GitHub[0m
ECHO [1m    11. [36m使用gh-proxy.org代理GitHub[0m
ECHO [1m    12. [36m使用gh.ddlc.top代理GitHub[0m
ECHO [1m    13. [36m使用www.ytools.cc/gh代理GitHub[0m
ECHO [1m    14. [36m使用git.yylx.win代理GitHub[0m
ECHO [1m    15. [36m使用ghfile.geekertao.top代理GitHub[0m
ECHO [1m    16. [36m使用ghm.078465.xyz代理GitHub[0m
ECHO [1m    17. [36m使用gitproxy.127731.xyz代理GitHub[0m
ECHO [1m    18. [36m使用jiashu.1win.eu.org代理GitHub[0m
ECHO [1m    19. [36m使用github.tbedu.top代理GitHub[0m
ECHO [1m     Q. [36m我不要设置了，我要退出[0m


:SETUP_MIRROR_INPUT

SET /p res=[1m^>^> 请输入：[0m

SET MIRROR_ADDR=

IF /i "%res%"=="0" (
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="1" (
  SET MIRROR_ADDR=https://bitbucket.org/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="2" (
  SET MIRROR_ADDR=https://codeberg.org/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="10" (
  SET MIRROR_ADDR=https://ghfast.top/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="11" (
  SET MIRROR_ADDR=https://gh-proxy.org/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="12" (
  SET MIRROR_ADDR=https://gh.ddlc.top/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="13" (
  SET MIRROR_ADDR=https://www.ytools.cc/gh/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="14" (
  SET MIRROR_ADDR=https://git.yylx.win/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="15" (
  SET MIRROR_ADDR=https://ghfile.geekertao.top/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="16" (
  SET MIRROR_ADDR=https://ghm.078465.xyz/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="17" (
  SET MIRROR_ADDR=https://gitproxy.127731.xyz/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="18" (
  SET MIRROR_ADDR=https://jiashu.1win.eu.org/https://github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="19" (
  SET MIRROR_ADDR=https://github.tbedu.top/github.com/
  GOTO MIRROR_WAS_SET
)
IF /i "%res%"=="Q" (
  EXIT /b 1
)
ECHO [91m 输入有误。[0m
GOTO SETUP_MIRROR_INPUT


:MIRROR_WAS_SET

REM Loop through all url.*.insteadOf entries
FOR /F "USEBACKQ tokens=1,* delims= " %%a IN (`"%GIT_PATH%" config --local --get-regexp ^^url\..*\.insteadOf$`) DO (
    IF "%%b"=="https://github.com/" (
        "%GIT_PATH%" config --unset-all "%%a"
    )
)

IF x%MIRROR_ADDR% NEQ x (
  "%GIT_PATH%" config --local url."%MIRROR_ADDR%".insteadOf "https://github.com/"
)

EXIT /b %errorlevel%


:CLONE_REPO

REM 如果仓库不存在，就Clone仓库

"%GIT_PATH%" config --global core.quotepath false
"%GIT_PATH%" config --global --add safe.directory "*"
IF EXIST "%CD%\%LocalFolder%\.git" EXIT /b 0
IF EXIST "%CD%\.git" (
  SET LocalFolder=.
  EXIT /b 0
)
FOR /F "tokens=* USEBACKQ" %%F IN (`ECHO %CD%`) DO (
  IF "%%~nF"=="%LocalFolder%" (
    SET LocalFolder=.
  )
)
ECHO [96m-- 未检测到已下载的蓝图仓库，将重新拉取。[0m

IF NOT EXIST "%LocalFolder%" (
  MKDIR "%LocalFolder%"
  IF %errorlevel% NEQ 0 (
    ECHO [91m 错误！[0m
    ECHO [91m!! 无法创建本地目录 %LocalFolder% 。请检查权限设置。[0m
    EXIT /b 1
  )
)

PUSHD %LocalFolder% 1>NUL 2>NUL
"%GIT_PATH%" init

REM 设置镜像
CALL :SETUP_MIRROR
IF %errorlevel% NEQ 0 (
  EXIT /b 1
)

ECHO [96m-- 正在拉取仓库。容量较大，请耐心等待...[0m
"%GIT_PATH%" remote add origin "%RepoUrl%"
"%GIT_PATH%" fetch --depth=1 origin
"%GIT_PATH%" reset --hard origin/main
"%GIT_PATH%" checkout -t origin/main
IF %errorlevel% NEQ 0 (
  ECHO [91m 错误！[0m
  ECHO [91m!! 仓库拉取失败。如果没有其他警告，这通常是网络波动，重试就行，无效请使用加速器/挂梯子后再更新。[0m
  POPD >NUL
  EXIT /b 2
)
ECHO [92m^<^< 蓝图文件拉取完毕，现在可以直接关闭此窗口。[0m
POPD >NUL
EXIT /b -1


:UPDATE_REPO

REM 拉取更新仓库

PUSHD %LocalFolder% 1>NUL 2>NUL
IF NOT EXIST ".\.gitignore" (
  "%GIT_PATH%" reset --hard 1>NUL 2>NUL
)

REM 检查远程路径，因为镜像的原因不再检查
REM FOR /F "tokens=* USEBACKQ" %%F IN (`"%GIT_PATH%" remote get-url origin`) DO (
REM   SET RemoteUrl=%%F
REM )
REM IF "%RemoteUrl%" NEQ "%RepoUrl%" (
REM   ECHO [96m-- 仓库URL不匹配，修改仓库URL...[0m
REM   "%GIT_PATH%" remote set-url origin "%RepoUrl%"
REM )

SET GIT_SSL_NO_VERIFY=true
ECHO | set /p=[96m-- 正在更新蓝图仓库...[0m
"%GIT_PATH%" pull origin main 1>NUL 2>NUL
IF %errorlevel% NEQ 0 (
  POPD >NUL
  ECHO [91m 错误！[0m
  ECHO [91m!! 更新失败。如果没有其他警告，这通常是网络波动，重试就行，建议使用加速器/挂梯子，或者切换镜像/代理后再更新。[0m
  EXIT /b 1
)

ECHO [96m 完成[0m
POPD 1>NUL 2>NUL
ECHO [92m^<^< 蓝图文件更新完毕。[0m
EXIT /b 0
