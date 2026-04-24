<?php

declare(strict_types=1);

namespace App\Providers;

use App\Application\Invoice\CreateInvoiceService;
use App\Application\Invoice\ListInvoicesService;
use App\Controllers\InvoiceController;
use App\Domain\Invoice\Contracts\InvoiceRepositoryInterface;
use App\Infrastructure\Invoice\InMemoryInvoiceRepository;
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Application;
use Phalcon\Mvc\Router;

final class ApplicationProvider
{
    public function create(): Application
    {
        $container = new FactoryDefault();

        $container->setShared('router', function (): Router {
            $router = new Router(false);
            $router->addPost('/invoices', ['controller' => 'invoice', 'action' => 'create']);
            $router->addGet('/invoices', ['controller' => 'invoice', 'action' => 'list']);
            return $router;
        });

        $container->setShared(
            InvoiceRepositoryInterface::class,
            static fn (): InvoiceRepositoryInterface => new InMemoryInvoiceRepository()
        );
        $container->setShared(
            CreateInvoiceService::class,
            fn (): CreateInvoiceService => new CreateInvoiceService($container->getShared(InvoiceRepositoryInterface::class))
        );
        $container->setShared(
            ListInvoicesService::class,
            fn (): ListInvoicesService => new ListInvoicesService($container->getShared(InvoiceRepositoryInterface::class))
        );
        $container->setShared(
            'invoiceController',
            fn (): InvoiceController => new InvoiceController(
                $container->getShared(CreateInvoiceService::class),
                $container->getShared(ListInvoicesService::class),
                $container->getShared('request')
            )
        );

        return new Application($container);
    }
}
