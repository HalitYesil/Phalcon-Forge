<?php

declare(strict_types=1);

/**
 * Minimal MCP-like stdio server for local development.
 * Protocol: one JSON object per line.
 * Request: {"id":"1","tool":"get_starter_scenario","arguments":{"name":"rest"}}
 */

final class LocalMcpServer
{
    private string $root;

    public function __construct(string $root)
    {
        $this->root = $root;
    }

    public function run(): void
    {
        while (($line = fgets(STDIN)) !== false) {
            $line = trim($line);
            if ($line === '') {
                continue;
            }

            $payload = json_decode($line, true);
            if (!is_array($payload)) {
                $this->write(['id' => null, 'error' => 'Invalid JSON request']);
                continue;
            }

            $id = $payload['id'] ?? null;
            $tool = $payload['tool'] ?? '';
            $args = is_array($payload['arguments'] ?? null) ? $payload['arguments'] : [];

            try {
                $result = $this->handleTool((string) $tool, $args);
                $this->write(['id' => $id, 'result' => $result]);
            } catch (Throwable $e) {
                $this->write(['id' => $id, 'error' => $e->getMessage()]);
            }
        }
    }

    private function handleTool(string $tool, array $args): array
    {
        return match ($tool) {
            'get_starter_scenario' => $this->getStarterScenario($args),
            'compare_scenarios' => $this->compareScenarios($args),
            'get_methods_by_category' => $this->getMethodsByCategory($args),
            'recommend_existing_phalcon_api' => $this->recommendExistingPhalconApi($args),
            'doctor_runtime' => $this->doctorRuntime($args),
            default => throw new RuntimeException("Unknown tool: {$tool}"),
        };
    }

    private function getStarterScenario(array $args): array
    {
        $name = (string) ($args['name'] ?? '');
        $scenarios = $this->readJson('phalcondocs/index/scenarios.json');
        if (!isset($scenarios[$name]) || !is_array($scenarios[$name])) {
            throw new RuntimeException('Scenario not found');
        }

        return ['name' => $name] + $scenarios[$name];
    }

    private function compareScenarios(array $args): array
    {
        $left = (string) ($args['left'] ?? '');
        $right = (string) ($args['right'] ?? '');
        $focus = (string) ($args['focus'] ?? 'architecture');

        $scenarios = $this->readJson('phalcondocs/index/scenarios.json');
        $l = $scenarios[$left] ?? null;
        $r = $scenarios[$right] ?? null;
        if (!is_array($l) || !is_array($r)) {
            throw new RuntimeException('One or both scenarios not found');
        }

        $differences = [
            [
                'aspect' => 'purpose',
                'leftValue' => (string) ($l['purpose'] ?? ''),
                'rightValue' => (string) ($r['purpose'] ?? ''),
                'note' => "Compared by {$focus}",
            ],
        ];

        return compact('left', 'right', 'focus', 'differences');
    }

    private function getMethodsByCategory(array $args): array
    {
        $category = (string) ($args['category'] ?? '');
        $version = (string) ($args['version'] ?? '');
        $index = $this->readJson('phalcondocs/index/methods-by-category.json');
        $items = $index[$category] ?? [];
        if (!is_array($items)) {
            $items = [];
        }

        return [
            'category' => $category,
            'version' => $version,
            'items' => $items,
        ];
    }

    private function recommendExistingPhalconApi(array $args): array
    {
        $useCase = (string) ($args['use_case'] ?? '');
        $index = $this->readJson('phalcondocs/index/methods-by-category.json');

        $recommendations = [];
        foreach ($index as $category => $items) {
            if (!is_array($items)) {
                continue;
            }
            foreach ($items as $item) {
                if (!is_array($item)) {
                    continue;
                }
                $recommendations[] = [
                    'namespace' => (string) ($item['namespace'] ?? ''),
                    'method' => (string) ($item['method'] ?? ''),
                    'reason' => "Matches category {$category} for {$useCase}",
                    'confidence' => 0.6,
                ];
            }
        }

        return [
            'use_case' => $useCase,
            'recommendations' => $recommendations,
        ];
    }

    private function doctorRuntime(array $args): array
    {
        $target = (string) ($args['target'] ?? '');
        $scenario = (string) ($args['scenario'] ?? '');
        $composePath = $this->root . '/docker/compose/docker-compose.yml';

        $checks = [
            [
                'name' => 'compose_file_exists',
                'status' => file_exists($composePath) ? 'ok' : 'fail',
                'message' => $composePath,
            ],
        ];

        $status = 'ok';
        foreach ($checks as $check) {
            if ($check['status'] === 'fail') {
                $status = 'fail';
                break;
            }
        }

        return compact('target', 'scenario', 'status', 'checks');
    }

    private function readJson(string $relativePath): array
    {
        $fullPath = $this->root . '/' . $relativePath;
        if (!file_exists($fullPath)) {
            throw new RuntimeException("Missing file: {$relativePath}");
        }
        $decoded = json_decode((string) file_get_contents($fullPath), true);
        if (!is_array($decoded)) {
            throw new RuntimeException("Invalid JSON: {$relativePath}");
        }
        return $decoded;
    }

    private function write(array $payload): void
    {
        fwrite(STDOUT, json_encode($payload, JSON_UNESCAPED_SLASHES) . PHP_EOL);
    }
}

$server = new LocalMcpServer(dirname(__DIR__));
$server->run();
