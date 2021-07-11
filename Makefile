all:
	# generate src files from templates
	python ./external/retro_palette/template_engine.py \
		./templates/light-template.vim \
		./autoload/retro/palette/light.vim
	nvim --headless +"source ./src/retro.vim | qa"
