<?php

declare(strict_types=1);

namespace App\Controllers;

use Phalcon\Http\Response;

final class IndexController
{
    public function indexAction(): Response
    {
        $response = new Response();
        $response->setJsonContent([
            'status' => 'ok',
            'starter' => 'basic',
            'framework' => 'phalcon'
        ]);
        return $response;
    }
}
