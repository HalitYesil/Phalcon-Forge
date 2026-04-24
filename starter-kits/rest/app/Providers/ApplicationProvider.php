<?php

declare(strict_types=1);

namespace App\Providers;

use App\Controllers\HealthController;
use App\Controllers\UserController;
use App\Http\SecurityHeaders;
use App\Validation\InputValidator;
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
            $router->addGet('/health', [
                'controller' => 'health',
                'action' => 'index',
            ]);
            $router->addPost('/users', [
                'controller' => 'user',
                'action' => 'create',
            ]);
            return $router;
        });

        $container->setShared('validator', static fn (): InputValidator => new InputValidator());
        $container->setShared('securityHeaders', static fn (): SecurityHeaders => new SecurityHeaders());
        $container->setShared('response', static fn (): Response => new Response());
        $container->setShared('healthController', static fn () => new HealthController());
        $container->setShared('userController', static fn () => new UserController(
            $container->getShared('validator'),
            $container->getShared('securityHeaders')
        ));

        return new Application($container);
    }
}
