#!/bin/bash -x:

echo Are you at themes folder y/n?
read IS_THEME_FOLDER
if [ $IS_THEME_FOLDER != 'y' ];then
  exit
fi
if ! [ -d bootstrap ];then
  composer require drupal/bootstrap
fi

echo Enter your bootstrap subtheme name!
read THEME_NAME

if [ -d $THEME_NAME ];then
  echo There is already folder with this name! Would you like to recreate? y/n
  read RECREARE
  if [ $RECREARE != 'y' ];then
     exit
  else
    rm -rf $THEME_NAME
  fi
fi

cp -R bootstrap/starterkits/sass $THEME_NAME

cd $THEME_NAME

tn='THEMENAME'
tt='THEMETITLE'
td='Bootstrap Sub-Theme (SASS)'
mv $tn.theme  $THEME_NAME.theme
mv $tn.starterkit.yml $THEME_NAME.info.yml

mv config/install/THEMENAME.settings.yml config/install/$THEME_NAME.settings.yml
mv config/schema/THEMENAME.schema.yml  config/schema/$THEME_NAME.schema.yml

sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tt/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tn/$THEME_NAME/g" config/schema/$THEME_NAME.schema.yml
sed -i -e "s/$tt/$THEME_NAME/g" config/schema/$THEME_NAME.schema.yml

rm *yml-e
rm THEMENAME.libraries.yml

echo 'global-styling:
  css:
    theme:
      assets/css/all.min.css: {}

bootstrap-scripts:
  js:
    assets/js/all.min.js: {}
' > "${THEME_NAME}.libraries.yml"

echo '{
  "name": "THEMENAME",
  "version": "1.0.0",
  "description": "<!-- @file Instructions for subtheming using the SASS Starterkit. --> <!-- @defgroup sub_theming_sass --> <!-- @ingroup sub_theming --> # SASS Starterkit",
  "main": "Gruntfile.js",
  "dependencies": {},
  "devDependencies": {
    "bootstrap": "~3.3.7",
    "grunt": "~0.4.5",
    "grunt-contrib-concat": "~1.0.1",
    "grunt-contrib-cssmin": "~1.0.1",
    "grunt-contrib-jshint": "^1.1.0",
    "grunt-contrib-sass": "^1.0.0",
    "grunt-contrib-uglify": "~2.0.0",
    "grunt-contrib-watch": "~0.6.1",
    "grunt-watch-change": "^0.1.1"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > package.json

echo "module.exports = function(grunt) {
  grunt.initConfig({
    //JShint settings
    jshint: {
      all: ['Gruntfile.js', 'js/*.js']
    },
    // Sass settings
   sass: {
      dist: {
        files: {
           'assets/css/all.css': 'sass/style.scss'
        }
      }
    },
    // Watch settings
    watch: {
      scripts: {
        files: ['js/*.js'],
        tasks: ['jshint'],
        options: {
          spawn: false
        }
      },
      sass: {
        files: ['sass/*'],
        tasks: ['sass']
      }
    },
    // Watch JS settings
    watchJSchange: {
      js: {
        match: ['js/**/*.js'],
        setConfig: ['jshint.changed.src'],
        tasks: ['jshint:changed', 'concat', 'uglify']
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
    },
    // CSSMIN settings
    cssmin: {
      target: {
        files: {
          'assets/css/all.min.css': ['assets/css/all.css']
        }
      }
    },
    // Uglify settings
    uglify: {
      my_target: {
        files: {
          'assets/js/all.min.js': ['assets/js/all.js']
        }
      }
    }
  });

  // Register tasks
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-watch-change');
  grunt.registerTask('watching', ['watchJSchange', 'watch']);
  grunt.registerTask('default', ['concat', 'uglify', 'sass', 'cssmin']);
};
" > Gruntfile.js
sed -i -e "s/$tn/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml
sed -i -e "s/$tn/$THEME_NAME/g" package.json
sed -i -e "s/$td/$THEME_NAME/g" $THEME_NAME.info.yml

npm install

sed -i -e "s/bootstrap\/sass/\node_modules\/bootstrap\/sass/g" sass/bootstrap.scss
sed -i -e "s/..\/bootstrap\/fonts/.\/..\/fonts/g" sass/variable-overrides.scss
sed -i -e "s/..\/node_modules\/bootstrap\/sass\/variables.scss/variables.scss/g" sass/bootstrap.scss
cp node_modules/bootstrap/sass/variables.scss sass/variables.scss
if ! [ -d assets ];then
  mkdir assets
fi

cp -R node_modules/bootstrap/fonts assets
rm *.yml-e
rm sass/*.scss-e
grunt
cd ..
