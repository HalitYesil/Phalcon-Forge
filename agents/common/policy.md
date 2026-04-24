# Common Agent Policy

## Zorunlu Kurallar

- Once mevcut Phalcon capability ara, sonra custom kod yaz.
- Tum girdi verilerini sanitize + validate et.
- Tum ciktilari uygun escape yontemi ile guvenli hale getir.
- `.env`, `context/`, plan artifact dosyalarini commit etme.
- `app/` mantik, `public/` web giris noktasi olarak ayrik kalmali.

## Standart Komut Sozlugu

- `analyze`: Sorunu ve mevcut capability'leri cikar
- `scaffold`: Sablon/iskelet olustur
- `review`: Risk, regresyon, test bosluklarini bul
- `secure`: Header, input/output, secret kurallarini uygula
- `test`: Unit/integration/smoke adimlarini kos
