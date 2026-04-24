<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Auth\SessionGuard;
use App\Http\SecurityHeaders;
use Phalcon\Http\Response;

final class ProfileController
{
    public function __construct(
        private readonly SessionGuard $guard,
        private readonly SecurityHeaders $headers
    ) {
    }

    public function indexAction(): Response
    {
        if (!$this->guard->check()) {
            return $this->error('UNAUTHORIZED', 'Authentication required', 401);
        }

        $response = new Response();
        $this->headers->apply($response);
        $response->setJsonContent([
            'success' => true,
            'data' => ['user' => $this->guard->user()]
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
            'error' => ['code' => $code, 'message' => $message]
        ]);
        return $response;
    }
}
