<?php

declare(strict_types=1);

namespace App\Domain\Invoice;

final class Invoice
{
    public function __construct(
        public readonly int $id,
        public readonly string $customerName,
        public readonly float $totalAmount
    ) {
    }
}
