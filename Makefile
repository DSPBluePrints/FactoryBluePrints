RAR = "C:/Program Files/WinRAR/Rar.exe"
GIT = ./MinGit/cmd/git.exe

FactoryBluePrints.rar: .git 双击更新蓝图仓库.bat MinGit/
	$(GIT) gc --aggressive --prune=now
	$(RAR) a -ma5 -md1024 -m5 -mt32 -htb -rr5p -QO+ $@ $^

clear:
	rm *.rar