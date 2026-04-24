<?php

declare(strict_types=1);

use App\Providers\ApplicationProvider;

require dirname(__DIR__) . '/vendor/autoload.php';

$provider = new ApplicationProvider();
$application = $provider->create();

echo $application->handle($_SERVER['REQUEST_URI'] ?? '/')->getContent();
