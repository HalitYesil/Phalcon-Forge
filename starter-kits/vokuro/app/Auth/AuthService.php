<?php

declare(strict_types=1);

namespace App\Auth;

final class AuthService
{
    public function attempt(string $email, string $password): ?array
    {
        $configuredEmail = $_ENV['DEMO_USER_EMAIL'] ?? 'demo@example.com';
        $configuredPasswordHash = $_ENV['DEMO_USER_PASSWORD_HASH'] ?? '';

        if ($configuredPasswordHash === '') {
            return null;
        }
        if (!hash_equals($configuredEmail, $email)) {
            return null;
        }
        if (!password_verify($password, $configuredPasswordHash)) {
            return null;
        }

        return [
            'id' => 1,
            'email' => $email,
            'roles' => ['user']
        ];
    }
}
