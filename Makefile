7Z = ./7-Zip/7z.exe
RAR = C:/Program Files/WinRAR/Rar.exe
GIT = ./MinGit/cmd/git.exe

FactoryBluePrints.rar: .git 双击更新蓝图仓库.bat MinGit/ 7-Zip/
	$(GIT) gc --aggressive --prune=now
	$(RAR) a -ma5 -md1024 -m5 -mt32 -htb -rr5p -QO+ $@ $^

FactoryBluePrints.7z: .git 双击更新蓝图仓库.bat MinGit/ 7-Zip/
	$(GIT) gc --aggressive --prune=now
	$(7Z) a -ms -mx=9 $@ $^

clear:
	rm FactoryBluePrints.7z