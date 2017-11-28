# Drupal 8 Bootstrap Subtheme generator

## Composer generator
This script creates a new sub-theme for Bootstrap SASS theme on a Drupal 8.x composer based installation.

#### Requirements
* Drupal 8.x composer based installation
* Node.js
* Npm
* Grunt (`npm install -g grunt-cli`)

#### Init

* 1 - Go to your Drupal installation folder.
* 2 - Run `curl -O https://raw.githubusercontent.com/mecmartini/drupal8-bootstrap-subtheme-gen/master/bootstrap_subtheme_composer_gen.sh`
* 4 - Make sure script is executable. Run `chmod +x bootstrap_subtheme_composer_gen.sh`
* 5 - Run `./bootstrap_subtheme_composer_gen.sh`
* 6 - Follow the instructions

#### Usage

* Run `grunt` inside your theme folder to compile all `*.scss` and `*.js` files.
* Run `grunt watch` inside your theme folder to watch changes on all `*.scss` and `*.js` files.

Note: all the files under `components/` folder aren't concatenated into the main `all.css` file for custom inclusion. That means you have to include them by yourself where you need them.




Enjoy your Drupal bootstrap subtheme :)