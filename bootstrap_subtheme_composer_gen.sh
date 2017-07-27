#!/bin/bash
# This script creates a new sub-theme for Bootstrap SASS theme on a Drupal 8.x composer based installation.
#
# Requirements:
# Drupal 8.x composer based installation
# NodeJS
# Npm
# Grunt (npm install -g grunt-cli)
#
# Usage:
# In your terminal: $ cd /your/drupal/root/directory
# Make sure script is executable : $ chmod +x bootstrap_subtheme_composer_gen.sh
# Run within directory: $ ./build-bootstrap-sass.sh
# Follow the instructions
#

# base directory
BASE_DIR="$( cd "$( dirname "$0" )" && pwd )"

# composer file
COMPOSER_FILE='composer.json'
if [ -f "$COMPOSER_FILE" ]
then
	echo "composer.json found"
	if grep -q 'drupal/core' $COMPOSER_FILE
	then
	    echo "Drupal composer based installation found..."
	else
	    echo "[Error] Drupal composer based installation not found!" 1>&2
	    exit 1
	fi
else
	echo "[Error] composer.json not found!" 1>&2
	exit 1
fi

# Get custom subtheme name
HUMANNAME=''
while [ -z "$HUMANNAME" ]
do
    echo -n "Enter a human-readable name for your bootstrap sub-theme: "
    read -e HUMANNAME
done

MACHINENAME=`echo $HUMANNAME | tr '[:upper:]' '[:lower:]' | sed -e 's/[ -]/_/g' -e 's/[^a-z0-9_]//g'`

if [ -d "$BASE_DIR/web/themes/custom/$MACHINENAME" ]
then
	echo -n "Sub-theme directory 'web/themes/custom/$MACHINENAME' already exists! Would you like to recreate it? [y/N]: "
	read -e RECREATE
    if [ -z "$RECREATE" ] || [ $RECREATE != 'y' ];then
        echo "[Error] Can't create the sub-theme, please run it again and choose a different name for your Bootstrap sub-theme!" 1>&2
        exit 1
    else
        rm -rf $BASE_DIR/web/themes/custom/$MACHINENAME
    fi
fi

if [ ! -d "$BASE_DIR/web/themes/contrib/bootstrap" ]
then
    echo "Installing Bootstrap base theme via composer..."
	composer require drupal/bootstrap
else
    echo "Bootstrap base theme found..."
fi

# Go to main themes/ directory
cd web/themes

# Copy sub-theme
echo 'Creating bootstrap sub-theme with SASS starter-kit...'
cp -R contrib/bootstrap/starterkits/sass custom/$MACHINENAME

# Go to created sub-theme directory
cd custom/$MACHINENAME

tn='THEMENAME'
tt='THEMETITLE'
td='Bootstrap Sub-Theme (SASS)'
mv $tn.theme  $MACHINENAME.theme
mv $tn.starterkit.yml $MACHINENAME.info.yml

mv config/install/THEMENAME.settings.yml config/install/$MACHINENAME.settings.yml
mv config/schema/THEMENAME.schema.yml  config/schema/$MACHINENAME.schema.yml

sed -i -e "s/$tn/$MACHINENAME/g" $MACHINENAME.info.yml
sed -i -e "s/$tt/$HUMANNAME/g" $MACHINENAME.info.yml
sed -i -e "s/$td/$HUMANNAME Bootstrap Sub-Theme (SASS)/g" $MACHINENAME.info.yml
sed -i -e "s/$tn/$MACHINENAME/g" config/schema/$MACHINENAME.schema.yml
sed -i -e "s/$tt/$HUMANNAME/g" config/schema/$MACHINENAME.schema.yml

rm THEMENAME.libraries.yml

echo 'global-styling:
  css:
    theme:
      assets/css/all.css: {}

bootstrap-scripts:
  js:
    assets/js/all.js: {}
' > "${MACHINENAME}.libraries.yml"

echo "Creating Npm config file 'package.json'..."
echo '{
  "name": "THEMENAME",
  "version": "1.0.0",
  "description": "<!-- @file Instructions for subtheming using the SASS Starterkit. --> <!-- @defgroup sub_theming_sass --> <!-- @ingroup sub_theming --> # SASS Starterkit",
  "main": "Gruntfile.js",
  "dependencies": {},
  "devDependencies": {
    "grunt": "~0.4.5",
    "grunt-sass": "^2.0.0",
    "grunt-contrib-concat": "~1.0.1",
    "grunt-contrib-watch": "~0.6.1",
    "grunt-watch-change": "^0.1.1"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > package.json

sed -i -e "s/$tn/$MACHINENAME/g" package.json

echo "Creating Grung config file 'Gruntfile.js'..."
echo "module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // Sass settings
    sass: {
      dist: {
        files: {
          'assets/css/all.css': 'scss/style.scss'
        }
      }
    },
    // Watch settings
    watch: {
      scripts: {
        files: ['js/*.js'],
        options: {
          spawn: false
        }
      },
      sass: {
        files: ['scss/*'],
        tasks: ['sass']
      }
    },
    // Watch JS settings
    watchJSchange: {
      js: {
        match: ['js/**/*.js'],
        tasks: ['concat']
      }
    },
    // Contact settings
    concat: {
      options: {
        separator: ';'
      },
      dist: {
        src: ['node_modules/bootstrap/dist/js/bootstrap.js', 'js/*.js'],
        dest: 'assets/js/all.js'
      }
    }
  });

  // Register tasks
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-watch-change');
  grunt.registerTask('watching', ['watchJSchange', 'watch']);
  grunt.registerTask('default', ['concat', 'sass']);
};
" > Gruntfile.js

echo "Install Npm dependencies..."
npm install

# Create necessary dirs
echo "Creating necessary directories..."
mkdir -p \
  bootstrap \
  bootstrap/assets \
  js \
  img \
  assets \
  assets/images \
  assets/js \
  assets/sass

# Get latest bootstarp-sass official code
echo "Getting latest 'bootstrap-sass' version..."
BOOTSTRAP_SASS_LATEST_VERSION=$($BASE_DIR/get-tag.awk https://github.com/twbs/bootstrap-sass)

# Build url for bootstrap-sass lastest srouce code
BOOTSTRAP_SASS_URL=https://github.com/twbs/bootstrap-sass/archive/$BOOTSTRAP_SASS_LATEST_VERSION.tar.gz

# Download bootstrap-sass source code
echo "Downloading bootstrap-sass $BOOTSTRAP_SASS_LATEST_VERSION.tar.gz package.."
wget $BOOTSTRAP_SASS_URL

# Unpacking
TARGZ_NAME=$BOOTSTRAP_SASS_LATEST_VERSION.tar.gz
echo "Unpacking $TARGZ_NAME .."
tar xzf $TARGZ_NAME

# Coping necessary assets
UNPACK_DIR_NAME=$(echo $BOOTSTRAP_SASS_LATEST_VERSION | sed 's/v/bootstrap-sass-/')
echo "Coping $UNPACK_DIR_NAME/assets.."
for DIR in `ls $UNPACK_DIR_NAME/assets`
do
  echo " > Coping $UNPACK_DIR_NAME/assets/$DIR ..."
  cp -R $UNPACK_DIR_NAME/assets/$DIR bootstrap/assets/
done

# Removing temp files
echo "Cleaning temp files..."
rm -rf $UNPACK_DIR_NAME $TARGZ_NAME

# Init Grunt
echo "Init Grunt..."
grunt

# Add Npm modules to .gitignore
echo "Add Npm modules to .gitignore..."
cd $BASE_DIR
echo "

# Custom bootstrap sub-theme $HUMANNAME
/web/themes/custom/$MACHINENAME/node_modules" >> .gitignore

# THE END
echo
echo -------------------------------------
echo "Bootstrap sub-theme '$HUMANNAME' has been created!"
echo
echo "From the created sub-theme '$MACHINENAME' directory run 'grunt' to process your file or 'grunt watch' to watch your project files for changes."
exit 0