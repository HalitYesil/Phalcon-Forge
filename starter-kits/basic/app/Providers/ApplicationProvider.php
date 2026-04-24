<?php

declare(strict_types=1);

namespace App\Providers;

use App\Controllers\IndexController;
use Phalcon\Di\FactoryDefault;
use Phalcon\Http\Response;
use Phalcon\Mvc\Application;
use Phalcon\Mvc\Router;

final class ApplicationProvider
{
    public function create(): Application
    {
        $container = new FactoryDefault();

        $container->setShared('router', function (): Router {
            $router = new Router(false);
            $router->addGet('/', [
                'controller' => 'index',
                'action' => 'index',
            ]);
            return $router;
        });

        $container->setShared('response', static fn (): Response => new Response());
        $container->setShared('indexController', static fn (): IndexController => new IndexController());

        $application = new Application($container);
        $application->registerModules([]);

        return $application;
    }
}
