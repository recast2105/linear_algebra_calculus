DefaultRun := @odin run .
ProjectName := ExploradorFuncoes

run:
	$(DefaultRun)

build-linux:
	@odin build . -target:linux_amd64 -out:$(ProjectName)

build-windows:
	@odin build . -target:windows_amd64 -out:$(ProjectName).exe

build: build-linux

clean:
	@rm -f $(ProjectName) $(ProjectName).exe

help:
	@echo "The following are some of the valid target for this Makefile:"
	@echo "... all (Default build and run)"
	@echo "... build-linux (Linux build)"
	@echo "... build-windows (Windows build)"
	@echo "... clean (Erase the build)"

.PHONY: run build build-linux build-windows clean help
