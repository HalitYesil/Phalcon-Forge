# Auth Flow Contract

## Endpoints

- `POST /auth/login`
- `POST /auth/logout`
- `GET /profile`

## Beklenen Davranis

- Gecerli login sonrasi `auth_user` session'a yazilir.
- Logout sonrasi `auth_user` session'dan silinir.
- `GET /profile` sadece authenticated kullaniciya veri dondurur.
