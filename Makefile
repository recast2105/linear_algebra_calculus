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

.PHONY: run build build-linux build-windows clean
