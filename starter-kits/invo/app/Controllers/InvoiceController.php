<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Application\Invoice\CreateInvoiceService;
use App\Application\Invoice\ListInvoicesService;
use Phalcon\Http\Request;
use Phalcon\Http\Response;

final class InvoiceController
{
    public function __construct(
        private readonly CreateInvoiceService $createService,
        private readonly ListInvoicesService $listService,
        private readonly Request $request
    ) {
    }

    public function createAction(): Response
    {
        $payload = $this->request->getJsonRawBody(true);
        if (!is_array($payload)) {
            return $this->error('INVALID_JSON', 'Request body must be valid JSON', 400);
        }

        $customerName = (string) ($payload['customerName'] ?? '');
        $amount = (float) ($payload['totalAmount'] ?? 0);

        $invoice = $this->createService->handle($customerName, $amount);
        if ($invoice === null) {
            return $this->error('INVALID_INPUT', 'customerName and positive totalAmount are required', 422);
        }

        $response = new Response();
        $response->setStatusCode(201, 'Created');
        $response->setJsonContent([
            'success' => true,
            'data' => [
                'id' => $invoice->id,
                'customerName' => htmlspecialchars($invoice->customerName, ENT_QUOTES, 'UTF-8'),
                'totalAmount' => $invoice->totalAmount,
            ],
        ]);
        return $response;
    }

    public function listAction(): Response
    {
        $items = array_map(static fn ($invoice) => [
            'id' => $invoice->id,
            'customerName' => htmlspecialchars($invoice->customerName, ENT_QUOTES, 'UTF-8'),
            'totalAmount' => $invoice->totalAmount,
        ], $this->listService->handle());

        $response = new Response();
        $response->setJsonContent([
            'success' => true,
            'data' => $items,
        ]);
        return $response;
    }

    private function error(string $code, string $message, int $status): Response
    {
        $response = new Response();
        $response->setStatusCode($status);
        $response->setJsonContent([
            'success' => false,
            'error' => [
                'code' => $code,
                'message' => $message,
            ],
        ]);
        return $response;
    }
}
