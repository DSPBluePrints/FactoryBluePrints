chcp 65001
@echo off

	set LOG_PATH=.\update.log

	dir > %LOG_PATH%

	echo ---- >> %LOG_PATH%

	echo INF: %date% %time% Start >> %LOG_PATH%

	if exist ".\MinGit\cmd\git.exe" (
		set GIT_PATH=.\MinGit\cmd\git.exe
		echo INF: %date% %time% GIT_PATH=MinGit >> %LOG_PATH%
	) else if exist "C:\Program Files\Git" (
		set GIT_PATH=git
		echo INF: %date% %time% GIT_PATH=Git >> %LOG_PATH%
	) else (
		echo 错误：无法找到Git或MinGit
		echo ERR: %date% %time% Git/MinGit no found >> %LOG_PATH%
		goto err
	)

	if exist ".\.git" (
		echo INF: %date% %time% ".git" found >> %LOG_PATH%
		goto git_init
	) else (
		echo 警告：没有找到.git文件夹
		echo WAR: %date% %time% ".git" no found >> %LOG_PATH%
		goto git_no_init
	)

:git_no_init
	echo 正在尝试重建.git
	echo INF: %date% %time% ".git" init start >> %LOG_PATH%
	%GIT_PATH% init
	%GIT_PATH% branch -M main
	%GIT_PATH% remote add origin https://github.com/DSPBluePrints/FactoryBluePrints.git
	echo INF: %date% %time% ".git" init end >> %LOG_PATH%

:git_init
	echo INF: %date% %time% git pull start >> %LOG_PATH%
	set GIT_SSL_NO_VERIFY=true
	%GIT_PATH% pull origin main
	echo INF: %date% %time% git pull end >> %LOG_PATH%

:end
	echo INF: %date% %time% Exit >> %LOG_PATH%
	pause
	exit

:err
	echo 存在异常，无法更新
	echo INF: %date% %time% Exit with error >> %LOG_PATH%
	pause
	exit