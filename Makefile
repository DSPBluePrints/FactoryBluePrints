ifeq ($(OS),Windows_NT)
    RAR := "C:/Program Files/WinRAR/Rar.exe"
    GIT := "C:/Program Files/Git/cmd/git.exe"
    PACKAGE_EXT := rar
    PACKAGE_CMD = $(RAR) a -ma5 -md1024 -m5 -mt32 -htb -s -rr1p -QO+ $@ $^
    PACKAGE_DEPS := .git update.bat README.md README_EN.md MinGit
else
    GIT := git
    PACKAGE_EXT := tar.gz
    PACKAGE_CMD = tar -czf $@ $^
    PACKAGE_DEPS := update.sh README.md README_EN.md
endif

FactoryBluePrints.$(PACKAGE_EXT): $(PACKAGE_DEPS)
	$(GIT) repack -a -d --window-memory=0 --depth=4095
	$(PACKAGE_CMD)

repack:
	$(GIT) config core.compression 9
	$(GIT) config core.looseCompression 9
	$(GIT) config pack.compression 9
	$(GIT) repack -a -d -f -F --window-memory=0 --depth=4095

clean:
ifeq ($(OS),Windows_NT)
	rm *.rar
else
	rm *.tar.gz
endif
