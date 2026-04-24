<?php

declare(strict_types=1);

namespace App\Providers;

use App\Auth\AuthService;
use App\Auth\SessionGuard;
use App\Controllers\AuthController;
use App\Controllers\ProfileController;
use App\Http\SecurityHeaders;
use App\Validation\InputValidator;
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Application;
use Phalcon\Mvc\Router;
use Phalcon\Session\Manager;
use Phalcon\Session\Adapter\Stream;

final class ApplicationProvider
{
    public function create(): Application
    {
        $container = new FactoryDefault();

        $container->setShared('router', function (): Router {
            $router = new Router(false);
            $router->addPost('/auth/login', ['controller' => 'auth', 'action' => 'login']);
            $router->addPost('/auth/logout', ['controller' => 'auth', 'action' => 'logout']);
            $router->addGet('/profile', ['controller' => 'profile', 'action' => 'index']);
            return $router;
        });

        $container->setShared('session', function (): Manager {
            $manager = new Manager();
            $adapter = new Stream([
                'savePath' => dirname(__DIR__, 2) . '/storage/sessions'
            ]);
            $manager->setAdapter($adapter);
            $manager->start();
            return $manager;
        });

        $container->setShared('securityHeaders', static fn (): SecurityHeaders => new SecurityHeaders());
        $container->setShared('validator', static fn (): InputValidator => new InputValidator());
        $container->setShared('authService', static fn (): AuthService => new AuthService());
        $container->setShared('sessionGuard', fn (): SessionGuard => new SessionGuard($container->getShared('session')));

        $container->setShared('authController', fn () => new AuthController(
            $container->getShared('authService'),
            $container->getShared('validator'),
            $container->getShared('session'),
            $container->getShared('securityHeaders')
        ));
        $container->setShared('profileController', fn () => new ProfileController(
            $container->getShared('sessionGuard'),
            $container->getShared('securityHeaders')
        ));

        return new Application($container);
    }
}
