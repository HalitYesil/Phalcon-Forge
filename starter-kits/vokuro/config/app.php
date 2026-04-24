<?php

declare(strict_types=1);

return [
    'name' => 'Phalcon Forge Vokuro',
    'env' => $_ENV['APP_ENV'] ?? 'local',
    'debug' => ($_ENV['APP_DEBUG'] ?? '0') === '1',
    'auth' => [
        'session_key' => 'auth_user',
    ],
];
