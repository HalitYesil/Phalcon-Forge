# Scenario Matrix

Bu dokuman, `basic`, `invo`, `rest`, `vokuro` starter-kit senaryolarinin ne zaman secilecegini ve birinden digerine gecis yolunu tanimlar.

## Hizli Secim Tablosu

| Scenario | Ne Icin | Guclu Taraf | Dikkat Noktasi |
|---|---|---|---|
| basic | Hızlı baslangic, minimal MVP | Dusuk karmasiklik | Buyudukce katmanlastirma gerekir |
| invo | Domain/modul odakli is uygulamalari | Temiz katman ayrimi | Ilk kurulum basic'e gore daha kapsamli |
| rest | API-first urunler | JSON contract + validation akisi | Auth/rate-limit gibi katmanlar eklenmeli |
| vokuro | Auth/session guvenlik agirlikli sistemler | Hazir auth akisi ve session guard | Domain servisleri sonradan genisletilmeli |

## Karar Kurallari

- Ilk hedef web + basit route ise `basic`
- Is kurallari hizla artis gosterecekse `invo`
- Mobil/web client API tuketecekse `rest`
- Login, oturum ve yetkilendirme erken asamada zorunluysa `vokuro`

## Gecis Stratejisi

### basic -> invo

- Controller icindeki is kurallarini `app/Application/*` servislerine tasi.
- Veri erisimini `Domain Contracts` + `Infrastructure` repository katmanina ayir.

### basic -> rest

- HTML odakli response yerine JSON success/error contract uygula.
- Input sanitize/validate ve hata kod sozlugunu sabitle.

### rest -> vokuro

- API endpointlerine session veya token guard ekle.
- Login/logout ve yetki kontrollerini merkezi auth katmanina tasiyin.

## Minimum Guvenlik Baseline

Tum senaryolarda asagidakiler zorunludur:

- Input sanitize/validate
- Output escape (HTML cikislarinda)
- Prepared statements
- CSP, X-Frame-Options, HSTS, X-Content-Type-Options
- Secretlerin `.env` uzerinden yonetimi
