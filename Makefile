all:
	@git submodule update --remote --rebase
	@python3 config.py
rime:
	RIME=1 python3 config.py
