# Proje Kayıt Defteri (PROJECTS.md)

Bu dosya sadece referans/takip amaçlı — her projenin kendi repo'sunda ayrıca
kendi `TASKS.md`'si olacak. Buraya yeni proje eklediğinde satır ekle.

| Proje | Repo | Durum | Öncelik | Notlar |
|---|---|---|---|---|
| lifesycle-live | (repo linkini ekle) | Aktif | Yüksek | |
| microsoft | (repo linkini ekle) | Aktif | Orta | |
| degenslide | (repo linkini ekle) | Aktif | Orta | |
| trendai | (repo linkini ekle) | Aktif | Orta | |
| sharesfor | (repo linkini ekle) | Aktif | Orta | |
| whitegrave | (repo linkini ekle) | Aktif | Orta | |
| (personal projeler) | — | Eklenecek | — | Yeni proje çıktıkça buraya satır ekle |

## Durum değerleri
- **Aktif** — agent her gece bakıyor
- **Beklemede** — agent dokunmuyor, ama listede duruyor
- **Tamamlandı** — arşivlendi, agent artık bakmıyor

## Yeni proje ekleme adımları
1. Repo'ya `.github/workflows/night-agent.yml` ve `TASKS.md` kopyala (KURULUM.md'deki adımlar).
2. Repo secrets'a `ANTHROPIC_API_KEY`, `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` ekle.
3. Bu tabloya satır ekle.
