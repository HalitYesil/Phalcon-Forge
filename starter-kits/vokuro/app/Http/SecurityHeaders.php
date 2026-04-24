<?php

declare(strict_types=1);

namespace App\Http;

use Phalcon\Http\Response;

final class SecurityHeaders
{
    public function apply(Response $response): void
    {
        $response->setHeader('Content-Security-Policy', "default-src 'self'");
        $response->setHeader('X-Frame-Options', 'DENY');
        $response->setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
        $response->setHeader('X-Content-Type-Options', 'nosniff');
    }
}
