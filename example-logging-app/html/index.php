<?php

require __DIR__.'/../vendor/autoload.php';

$app = new Silex\Application();
$app['debug'] = true;
$app->register(new Silex\Provider\MonologServiceProvider(), [
    'monolog.handler' => new Monolog\Handler\SyslogHandler('logging-app')
]);

if (class_exists('Sorien\Provider\PimpleDumpProvider')) {
    $app->register(new Sorien\Provider\PimpleDumpProvider());
}

$app->get('/hello/{name}', function ($name) use ($app) {
    $app['monolog']->addInfo("Hello $name");
    return 'Hello '.$app->escape($name);
});

$app->run();
