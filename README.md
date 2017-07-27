# Drupal 8 Bootstrap Subtheme generator

## Drush generator

#### Requirements
* Drupal 8.x
* Drupal Bootstrap 8.3.x theme
* Node.js

#### Usage

Go to your drupal subtheme folder (or create this one).

* 1 - download boostrap from http://getbootstrap.com/getting-started/#download (sass version);
* 2 - When you decompress the Bootstrap SASS archive, the only parts you want are in the assets folder. Pick up everything in that folder and paste it into your new theme’s bootstrap folder at drupalroot/themes/mytheme/bootstrap.
* 3 - Run `curl -O https://rawgit.com/valeriopisapia/drupal8-bootstrap-subtheme-gen/master/bootstrap_subtheme_drush_gen.sh`
* 4 - Make sure script is executable. Run `chmod +x bootstrap_subtheme_drush_gen.sh`
* 5 - Run `./bootstrap_subtheme_drush_gen.sh`
* 6 - Follow the instructions


## Composer generator
This script creates a new sub-theme for Bootstrap SASS theme on a Drupal 8.x composer based installation.

#### Requirements
* Drupal 8.x composer based installation
* Node.js
* Npm
* Grunt (npm install -g grunt-cli)

#### Usage

* 1 - Go to your Drupal installation folder.
* 2 - Run `curl -O https://raw.githubusercontent.com/valeriopisapia/drupal8-bootstrap-subtheme-gen/master/bootstrap_subtheme_composer_gen.sh`
* 3 - Run `curl -O https://raw.githubusercontent.com/valeriopisapia/drupal8-bootstrap-subtheme-gen/master/get-tag.awk`
* 4 - Make sure scripts are executable. Run `chmod +x bootstrap_subtheme_drush_gen.sh get-tag.awk`
* 5 - Run `./bootstrap_subtheme_composer_gen.sh`
* 6 - Follow the instructions




Enjoy your Drupal bootstrap subtheme :)