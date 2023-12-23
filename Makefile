RAR = "C:/Program Files/WinRAR/Rar.exe"
GIT = ./MinGit/cmd/git.exe

FactoryBluePrints.rar: .git update.bat README.md README_EN.md MinGit
	$(GIT) repack -a -d --depth=4095 --window=4095
	$(RAR) a -ma5 -md1024 -m5 -mt32 -htb -s -rr1p -QO+ $@ $^

clean:
	$(GIT) repack -a -d --depth=4095 --window=4095
	rm *.rar
