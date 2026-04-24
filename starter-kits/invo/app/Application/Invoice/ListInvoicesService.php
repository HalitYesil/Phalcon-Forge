<?php

declare(strict_types=1);

namespace App\Application\Invoice;

use App\Domain\Invoice\Contracts\InvoiceRepositoryInterface;

final class ListInvoicesService
{
    public function __construct(private readonly InvoiceRepositoryInterface $repository)
    {
    }

    public function handle(): array
    {
        return $this->repository->list();
    }
}
