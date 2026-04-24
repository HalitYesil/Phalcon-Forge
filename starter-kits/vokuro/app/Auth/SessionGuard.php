<?php

declare(strict_types=1);

namespace App\Auth;

use Phalcon\Session\Manager;

final class SessionGuard
{
    public function __construct(private readonly Manager $session)
    {
    }

    public function user(): ?array
    {
        $user = $this->session->get('auth_user');
        return is_array($user) ? $user : null;
    }

    public function check(): bool
    {
        return $this->user() !== null;
    }
}
