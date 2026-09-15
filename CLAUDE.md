# CLAUDE.md — maybeno-agent Monorepo Rehberi

Bu dosya, bu repoda (interaktif olarak Claude Code ile) çalışan herkes
için kök seviyesi rehberdir. Otomatik gece/gündüz ajanları için bağlayıcı
kurallar `anayasa.md` dosyasındadır — bu dosyayı da mutlaka oku, çelişki
olursa `anayasa.md` üstün gelir.

## Bu Repo Ne

Tek bir GitHub repo altında yaşayan, birbirinden bağımsız çalışan birden
fazla "ajan" barındırıyoruz. Her ajan kendi alt klasöründe yaşıyor, kendi
GitHub Actions workflow'larıyla belirli bir cron'da tetikleniyor, Claude
Code CLI'yi (`claude -p "..."`) çağırıyor ve sonucu Telegram'a gönderiyor.
Kalıcı durum/hafıza veritabanı yok — her şey repodaki Markdown dosyalarında
tutuluyor (bkz. `AGENTS-OVERVIEW-EN.md` için tam liste).

Ajanlar:
- `maybeno-ders-agent` — ders/sınav takip ve pekiştirme
- `maybeno-finans-agent` — burs/yatırım/fırsat taraması (asla kişisel
  finansal tavsiye vermez)
- `maybeno-ingilizce-agent` — günlük İngilizce pratiği
- `maybeno-tech-haber` — günlük AI/yazılım haber özeti
- `maybeno-yarisma-agent` — yarışma/hackathon değerlendirme ve takip
- `maybeno-yazilim-ogretmen` — kullanıcının kendi projelerini öğretme
- `maybeno-bekci-agent` — diğer tüm ajanları anayasaya uygunluk ve
  sağlık açısından denetleyen gözetmen ajan

## Her Ajan Klasörünün Zorunlu İçeriği

```
<ajan-adi>/
  README.md          → ajanın amacı, veri dosyaları, workflow listesi
  KIMLIK.md           → ajanın kimliği: kim, görevi, tonu, sınırları
  HATA-DEFTERI.md      → öğrendiği dersler / yaptığı hatalar (bkz. anayasa.md §4)
  SKILLS.md            → kendi kendine geliştirdiği yöntemler/kısayollar
  hata-arsivi/          → HATA-DEFTERI.md rotasyonundan çıkan özet dosyalar
  .github/workflows/    → cron ile tetiklenen workflow'lar
```

Her workflow'un `claude -p` prompt'u şu sırayla başlamalıdır:
1. `anayasa.md` oku
2. Kendi `KIMLIK.md` oku
3. Kendi `HATA-DEFTERI.md` oku
4. Kendi `SKILLS.md` oku
5. Asıl görev (TASKS.md / konu listesi / vs.)

ve şu şekilde bitmelidir: kısa özet (`ÖZET:`) + varsa yeni ders/hatayı
`HATA-DEFTERI.md`'ye ekleme talimatı + rotasyon kontrolü.

## Sırlar / Secrets

- Gerçek anahtarlar (`ANTHROPIC_API_KEY`, `TELEGRAM_BOT_TOKEN`,
  `TELEGRAM_CHAT_ID`) **asla** repoya commit edilmez. Bunlar her repo için
  GitHub → Settings → Secrets and variables → Actions altına eklenir —
  workflow'lar oradan `secrets.X` ile okur.
- `.env` sadece yerel referans/test amaçlıdır, `.gitignore`'da listelidir,
  GitHub Actions bu dosyayı okumaz. Şablon için `.env.example`'a bak.
- Bir ajan `.env` veya secret içeren bir dosyayı asla okumaz/commit'lemez
  (bkz. `anayasa.md` §1).

## Yeni Ajan Eklerken

1. Yukarıdaki zorunlu klasör yapısını oluştur.
2. `night-agent.yml` desenini örnek al (bkz. kök `.github/workflows/`),
   ama ajanın kendi cron'una ve göreve göre uyarla.
3. `anayasa.md`'nin §6 bölümündeki checklist'i uygula.
4. `PROJECTS.md`'ye (bu proje merkezi kayıt için değil, ajan listesi
   içindir) veya `AGENTS-OVERVIEW-EN.md`'ye satır ekle.
5. Workflow'u Actions → "Run workflow" ile elle tetikleyip Telegram
   mesajının geldiğini doğrula.

## Commit / PR Kuralları

`anayasa.md` §1-3 bağlayıcıdır: bellek dosyaları (`HATA-DEFTERI.md`,
`SKILLS.md`, `hata-arsivi/*`) hariç her şey ayrı branch + PR ile gider,
main'e doğrudan push yok.
