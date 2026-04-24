<?php

declare(strict_types=1);

use App\Providers\ApplicationProvider;
use Phalcon\Http\Response;

require dirname(__DIR__) . '/vendor/autoload.php';

$provider = new ApplicationProvider();
$application = $provider->create();

try {
    $response = $application->handle($_SERVER['REQUEST_URI'] ?? '/');
} catch (Throwable $e) {
    $response = new Response();
    $response->setStatusCode(500, 'Internal Server Error');
    $response->setJsonContent([
        'success' => false,
        'error' => [
            'code' => 'INTERNAL_ERROR',
            'message' => 'Unexpected server error',
        ],
    ]);
}

echo $response->getContent();
