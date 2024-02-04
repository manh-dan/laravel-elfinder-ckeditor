## elFinder Package for Laravel

### For Laravel 8.x and older, please use the latest 0.4 version.

[![Packagist License](https://poser.pugx.org/barryvdh/laravel-elfinder/license.png)](http://choosealicense.com/licenses/mit/)
[![Latest Stable Version](https://poser.pugx.org/barryvdh/laravel-elfinder/version.png)](https://packagist.org/packages/barryvdh/laravel-elfinder)
[![Total Downloads](https://poser.pugx.org/barryvdh/laravel-elfinder/d/total.png)](https://packagist.org/packages/barryvdh/laravel-elfinder)

This packages integrates [elFinder](https://github.com/Studio-42/elFinder),
by making the php files available with Composer (+autoloading) and the assets with a publish command. It also provides some example views for standalone, tinymce and ckeditor.
Files are updated from the a seperate [build repository](https://github.com/barryvdh/elfinder-builds)

> Note: Use `php artisan elfinder:publish` instead of the old publish command, for future changes!

![image](https://user-images.githubusercontent.com/973269/158461690-2e6431a1-3a36-43f2-8219-0a21cee85ffc.png)

### Installation

Require this package with Composer

    composer require barryvdh/laravel-elfinder

Add the ServiceProvider to the providers array in app/config/app.php

```php
Barryvdh\Elfinder\ElfinderServiceProvider::class
```

You need to copy the assets to the public folder, using the following artisan command:

    php artisan elfinder:publish

Remember to publish the assets after each update (or add the command to your post-update-cmd in composer.json)

Routes are added in the ElfinderServiceProvider. You can set the group parameters for the routes in the configuration.
You can change the prefix or filter/middleware for the routes. If you want full customisation, you can extend the ServiceProvider and override the `map()` function.

### Configuration

The default configuration requires a directory called 'files' in the public folder. You can change this by publishing the config file.

    php artisan vendor:publish --provider='Barryvdh\Elfinder\ElfinderServiceProvider' --tag=config

In your config/elfinder.php, you can change the default folder, the access callback or define your own roots.

### Views

You can override the default views by copying the resources/views folder. You can also do that with the `vendor:publish` command:

    php artisan vendor:publish --provider='Barryvdh\Elfinder\ElfinderServiceProvider' --tag=views

### Using Filesystem disks

Laravel has the ability to use Flysystem adapters as local/cloud disks. You can add those disks to elFinder, using the `disks` config.

This examples adds the `local` disk and `my-disk`:

```php
'disks' => [
    'local',
    'my-disk' => [
        'URL' => url('to/disk'),
        'alias' => 'Local storage',
    ]
],
```

You can add an array to provide extra options, like the URL, alias etc. [Look here](https://github.com/Studio-42/elFinder/wiki/Connector-configuration-options-2.1#root-options) for all options. If you do not provide an URL, the URL will be generated by the disk itself.

### Using Glide for images

See [elfinder-flysystem-driver](https://github.com/barryvdh/elfinder-flysystem-driver) for [Glide](http://glide.thephpleague.com/) usage. A basic example with a custom Laravel disk and Glide would be:

1. Add the disk to your apps config/filesystems disks:

   ```php
   'public' => [
       'driver' => 'local',
       'root'   => base_path().'/public',
   ],
   ```

   > Tip: you can use the `extend` method to register your own driver, if you want to use non-default Flysystem disks

2. Create a Glide Server for your disk, eg. on the `glide/<path>` route, using a cache path:

   ```php
   Route::get('glide/{path}', function($path){
       $server = \League\Glide\ServerFactory::create([
           'source' => app('filesystem')->disk('public')->getDriver(),
       'cache' => storage_path('glide'),
       ]);
       return $server->getImageResponse($path, Input::query());
   })->where('path', '.+');
   ```

4. Add the disk to your elfinder config:

   ```php
   'disks' => [
       'public' => [
           'glideURL' => '/glide',
       ],
   ],
   ```

5. (Optional) Add the `glideKey` also to the config, and verify the key in your glide route using the Glide HttpSignature.

You should now see a root 'public' in elFinder with the files in your public folder, with thumbnails generated by Glide.
URLs will also point to the Glide server, for images.

### CKeditor 5.x
Download the source code for setting up elFinder for CKEditor using the following command:

    curl https://raw.githubusercontent.com/manh-dan/laravel-elfinder-ckeditor/main/build.sh | bash

To be able to use elFinder on a web page you have to include the main elFinder JavaScript file. The preferred way to do that is to include the elFinder setup template, as shown below:

    @include('elfinder.setup')

In the CKeditor config file:

```javascript
window.addEventListener("load", (e)=> {
    ClassicEditor
        .create(document.querySelector('#editor') , {
            toolbar: ['heading', '|', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'imageUpload', 'ckfinder', 'blockQuote', 'insertTable', 'mediaEmbed', 'undo', 'redo']
        } )
        .then(editor => {
            setupELFinder(editor)
        })
        .catch(error => {
            console.error( error );
        });
});
```
