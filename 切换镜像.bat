@echo off

chcp 65001 >NUL

SETLOCAL enableextensions enabledelayedexpansion

REM 本地目录，如果当前目录有.git文件夹的存在，则不使用此目录
SET LocalFolder=FactoryBluePrints

REM 设置MinGit
CALL "一键更新仓库.bat" SETUP_MINGIT

IF %errorlevel% NEQ 0 (
  GOTO END
)

IF EXIST "%CD%\%LocalFolder%\.git" GOTO SET_MIRROR
IF EXIST "%CD%\.git" (
  SET LocalFolder=.
  GOTO SET_MIRROR
)
FOR /F "tokens=* USEBACKQ" %%F IN (`ECHO %CD%`) DO (
  IF "%%~nF"=="%LocalFolder%" (
    SET LocalFolder=.
  )
)

ECHO [96m-- 未检测到已下载的蓝图仓库。[0m
GOTO END

:SET_MIRROR
PUSHD %LocalFolder% 1>NUL 2>NUL

REM 设置镜像
CALL "%~dp0一键更新仓库.bat" SETUP_MIRROR

POPD 1>NUL 2>NUL

:END

ENDLOCAL
ECHO [92m 按任意键关闭此窗口...[0m
PAUSE >NUL
