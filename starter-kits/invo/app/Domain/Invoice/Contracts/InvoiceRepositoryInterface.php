<?php

declare(strict_types=1);

namespace App\Domain\Invoice\Contracts;

use App\Domain\Invoice\Invoice;

interface InvoiceRepositoryInterface
{
    public function create(string $customerName, float $totalAmount): Invoice;

    /**
     * @return Invoice[]
     */
    public function list(): array;
}
