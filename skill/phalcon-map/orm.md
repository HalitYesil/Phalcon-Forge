# ORM Kategorisi

## Kart: Model Save

- namespace: `Phalcon\\Mvc\\Model`
- method: `save(): bool`
- amac: Model verisini insert/update olarak persiste etmek.
- ne_zaman_kullanilir: Entity odakli is akisi ve model hook'lari gerekli ise.
- ne_zaman_kullanilmaz: Buyuk toplu yazimda ham SQL daha verimli ise.
- alternatif_phalcon_cozumu: `Phalcon\\Db\\Adapter\\Pdo\\*` ile prepared statement.
- anti_pattern: Validasyon ve hata kontrolu olmadan `save()` cagirmak.
