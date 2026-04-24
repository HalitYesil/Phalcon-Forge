# PhalconDocs MCP Server

Bu dizin, PhalconDocs uzerinden agent'lara arac saglayacak MCP server tanimlarini tutar.

## Ilk Tool Seti

- `search_docs`
- `get_symbol`
- `get_methods_by_category`
- `recommend_existing_phalcon_api`
- `get_starter_scenario`
- `doctor_runtime`
- `compare_scenarios`

## Veri Kaynaklari

- `phalcondocs/index/manifest.json`
- `phalcondocs/index/symbols.json`
- `phalcondocs/index/methods-by-category.json`
- `phalcondocs/index/scenarios.json`

## Sozlesmeler

- Input schema: `mcp-server/tools/*.json` icindeki `inputSchema`
- Output schema: `mcp-server/schemas/output/*.output.schema.json`

## Local Calistirma

- Baslat: `php mcp-server/server.php`
- Protokol: STDIN/STDOUT uzerinden satir bazli JSON
- Ornek istek:
  - `{"id":"1","tool":"get_starter_scenario","arguments":{"name":"rest"}}`
