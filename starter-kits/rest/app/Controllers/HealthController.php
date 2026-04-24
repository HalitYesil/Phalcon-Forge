<?php

declare(strict_types=1);

namespace App\Controllers;

use Phalcon\Http\Response;

final class HealthController
{
    public function indexAction(): Response
    {
        $response = new Response();
        $response->setJsonContent([
            'success' => true,
            'data' => [
                'status' => 'ok',
                'service' => 'rest-starter'
            ]
        ]);
        return $response;
    }
}
