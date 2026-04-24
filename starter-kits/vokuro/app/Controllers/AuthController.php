<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Auth\AuthService;
use App\Http\SecurityHeaders;
use App\Validation\InputValidator;
use Phalcon\Http\Response;
use Phalcon\Session\Manager;

final class AuthController
{
    public function __construct(
        private readonly AuthService $authService,
        private readonly InputValidator $validator,
        private readonly Manager $session,
        private readonly SecurityHeaders $headers
    ) {
    }

    public function loginAction(): Response
    {
        $payload = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($payload)) {
            return $this->error('INVALID_JSON', 'Request body must be valid JSON', 400);
        }

        $email = $this->validator->sanitizeEmail($payload['email'] ?? null);
        $password = $payload['password'] ?? null;
        if (!is_string($email) || !is_string($password) || $password === '') {
            return $this->error('INVALID_INPUT', 'Email and password are required', 422);
        }

        $user = $this->authService->attempt($email, $password);
        if ($user === null) {
            return $this->error('AUTH_FAILED', 'Invalid credentials', 401);
        }

        $this->session->set('auth_user', $user);
        $response = new Response();
        $this->headers->apply($response);
        $response->setJsonContent([
            'success' => true,
            'data' => ['user' => $user]
        ]);
        return $response;
    }

    public function logoutAction(): Response
    {
        $this->session->remove('auth_user');
        $response = new Response();
        $this->headers->apply($response);
        $response->setJsonContent([
            'success' => true,
            'data' => ['loggedOut' => true]
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
