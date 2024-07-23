RAR = "C:/Program Files/WinRAR/Rar.exe"
GIT = "C:/Program Files/Git/cmd/git.exe"

FactoryBluePrints.rar: .git update.bat README.md README_EN.md MinGit
	$(GIT) repack -a -d --window-memory=0 --depth=4095
	$(RAR) a -ma5 -md1024 -m5 -mt32 -htb -s -rr1p -QO+ $@ $^

repack:
	$(GIT) config core.compression 9
	$(GIT) config core.looseCompression 9
	$(GIT) config pack.compression 9
	$(GIT) repack -a -d -f -F --window-memory=0 --depth=4095

clean:
	rm *.rar
