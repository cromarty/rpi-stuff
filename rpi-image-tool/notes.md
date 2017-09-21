
# Creating the initial .pot

	xgettext -L Shell -o <out.pot> <in files ...>

Can do more than one input file.

# `sed` Command to update \CHARSET\

	sed -i 's|=CHARSET|=UTF-8|' out.pot

# `.pot` and `.po` Files

A `.pot` file is the same format as `.po`.

There should only be one `.po` file, while there could be many `.pot` files to merge into it.

# msgmerge

	msgmerge -U existing.po new.pot

# Copying `.po` Files to Destination

The `.po` files will be changed into `.mo` files in the next step.

# `msgfmt` 

		
	msgfmt -o strings.mo strings.po

