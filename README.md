## INSTRUCTIONS

### php

habilitar el GD en el php.ini

### install libraries.


direktor-hito3 > npm install
direktor-hito3 > composer install

direktor-hito3/vue > npm install

### restore database

use database that is
direktor-hito3/backup db direktor/dump-appdb23-202302261045.sql

### envs

find the file env.txt and delete the extension txt.
direktor-hito3/env     => thus.


find the file env.txt and delete the extension txt in the folder vue.
direktor-hito3/vue/env    => thus


### run the proyect
direktor-hito3 > php artisan serve
direktor-hito3/vue > npm run dev


## prender las colas
php artisan queue:work --queue=high,default
php artisan queue:work --queue=default
php artisan queue:listen connection

php artisan queue:work

############# production #############3

## build vue js
direktor-hito3/vue > npm install
direktor-hito3/vue > npm run build 

## clean cache routes
php artisan route:clear

## clean cache
php artisan cache:clear

## clean view
php artisan view:clear

## start queue in production
nohup php artisan queue:work &

## in the other moment
https://laravel-news.com/how-to-run-workers-in-production
 -- install supervisor or admins queue


## LIBRERIA QUE SE UTILIZA PARA EL DRAG.

https://github.com/SortableJS/vue.draggable.next/blob/master/example/components/table-example.vue

## SEGUNDA LIBRERIA DE DRAG PERO NO FUNCIONA EN MOBIL
https://amendx.github.io/vue-dndrop/examples/table-drag.html

## INTERESANTE DE IMPLEMENTAR

https://dev.to/gaisinskii/draggable-table-row-with-vuejs-vuetify-and-sortablejs-1o7l
