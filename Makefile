all:
	# generate src files from templates
	python ./external/retro_palette/template_engine.py \
		./templates/light-template.vim \
		./autoload/retro/palette/light.vim
	nvim +'cd src | source retro.vim | qa' 2>&1 > /dev/null
