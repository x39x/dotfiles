all:
	@git submodule update --init --recursive
	@python3 config.py
