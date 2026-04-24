<?php

declare(strict_types=1);

namespace App\Application\Invoice;

use App\Domain\Invoice\Contracts\InvoiceRepositoryInterface;
use App\Domain\Invoice\Invoice;

final class CreateInvoiceService
{
    public function __construct(private readonly InvoiceRepositoryInterface $repository)
    {
    }

    public function handle(string $customerName, float $totalAmount): ?Invoice
    {
        $customerName = trim($customerName);
        if ($customerName === '' || $totalAmount <= 0) {
            return null;
        }

        return $this->repository->create($customerName, $totalAmount);
    }
}
