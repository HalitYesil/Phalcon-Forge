<?php

declare(strict_types=1);

return [
    'name' => 'Phalcon Forge Rest',
    'env' => $_ENV['APP_ENV'] ?? 'local',
    'debug' => ($_ENV['APP_DEBUG'] ?? '0') === '1',
    'api' => [
        'version' => 'v1',
        'base_path' => '/api',
    ],
];
