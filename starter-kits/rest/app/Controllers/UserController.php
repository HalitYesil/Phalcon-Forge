<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Http\SecurityHeaders;
use App\Validation\InputValidator;
use Phalcon\Http\Response;

final class UserController
{
    public function __construct(
        private readonly InputValidator $validator,
        private readonly SecurityHeaders $headers
    ) {
    }

    public function createAction(): Response
    {
        $payload = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($payload)) {
            return $this->error('INVALID_JSON', 'Request body must be valid JSON', 400);
        }

        $email = $this->validator->sanitizeEmail($payload['email'] ?? null);
        if ($email === null) {
            return $this->error('INVALID_INPUT', 'Valid email is required', 422);
        }

        $response = new Response();
        $this->headers->apply($response);
        $response->setStatusCode(201, 'Created');
        $response->setJsonContent([
            'success' => true,
            'data' => [
                'id' => 1,
                'email' => $email
            ]
        ]);
        return $response;
    }

    private function error(string $code, string $message, int $status): Response
    {
        $response = new Response();
        $this->headers->apply($response);
        $response->setStatusCode($status);
        $response->setJsonContent([
            'success' => false,
            'error' => [
                'code' => $code,
                'message' => $message
            ]
        ]);
        return $response;
    }
}
