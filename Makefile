all:
	@git submodule update --remote --rebase
	@python3 config.py
