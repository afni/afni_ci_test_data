#!/bin/bash
set -e
datalad create afni_atlases/
cd afni_atlases/

# Stringent conditions for what a "big" file is:
echo '**/.git* annex.largefiles=nothing' >> .gitattributes
datalad save -m 'everything is a large file'

# Get the atlases
datalad run -m 'add atlases' 'rsync  -a afni:/fraid/pub/dist/atlases/current/* atlases'

# Add the setup script
cp ../setup_script.sh .
datalad save -m 'add setup script'

# Add create a sibling for the afni server
datalad create-sibling  --as-common-datasrc afni_server  --ui true  --target-url https://afni.nimh.nih.gov/pub/dist/data/afni_atlases/.git afni:/fraid/pub/dist/data/afni_atlases

# Need to modify .git/config to change "afni" to "afni_server". Not sure why
# this happens. Other problems occur if I try to rename the command data
# source as afni. Then execute the following:

#  Add a sibling on github
# datalad create-sibling-github  --github-organization afni --existing reconfigure --publish-depends afni_server --access-protocol ssh afni_atlases

# Publish
# git push -u github master:master
# datalad publish
