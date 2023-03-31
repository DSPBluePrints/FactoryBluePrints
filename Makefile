7Z = ./7-Zip/7z.exe
GIT = ./MinGit/cmd/git.exe

FactoryBluePrints.7z: .git 双击更新蓝图仓库.bat MinGit/ 7-Zip/
	$(GIT) pull origin main
	$(GIT) gc --aggressive --prune=now
	$(7Z) a -ms -mx=9 $@ $^

clear:
	rm FactoryBluePrints.7z