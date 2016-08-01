/*

 Copyright 2015 Comcast Cable Communications Management, LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 */

module.exports = {
    options: {
        sassDir: '<%= globalConfig.srcdir %>',
        imagesDir: '<%= globalConfig.srcdir %>/assets/images',
        javascriptsDir: '<%= globalConfig.srcdir %>',
        fontsDir: '<%= globalConfig.srcdir %>/assets/fonts',
        importPath: '<%= globalConfig.app %>/bower_components',
        relativeAssets: false,
        assetCacheBuster: false,
        raw: 'Sass::Script::Number.precision = 10\n'
    },
    prod: {
        options: {
            cssDir: '<%= globalConfig.resourcesdir %>',
            outputStyle: 'compressed',
            environment: 'production'
        }
    },
    dev: {
        options: {
            debugInfo: true,
            cssDir: '<%= globalConfig.resourcesdir %>',
            outputStyle: 'expanded',
            environment: 'development'
        }
    }
};