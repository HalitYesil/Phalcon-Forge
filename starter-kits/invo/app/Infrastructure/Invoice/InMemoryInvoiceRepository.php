<?php

declare(strict_types=1);

namespace App\Infrastructure\Invoice;

use App\Domain\Invoice\Contracts\InvoiceRepositoryInterface;
use App\Domain\Invoice\Invoice;

final class InMemoryInvoiceRepository implements InvoiceRepositoryInterface
{
    /** @var Invoice[] */
    private array $invoices = [];
    private int $counter = 0;

    public function create(string $customerName, float $totalAmount): Invoice
    {
        $this->counter++;
        $invoice = new Invoice($this->counter, $customerName, $totalAmount);
        $this->invoices[] = $invoice;
        return $invoice;
    }

    public function list(): array
    {
        return $this->invoices;
    }
}
