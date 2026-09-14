# Proje Yönetim Agent'ı — Kurulum

Bu kit: GitHub Actions üzerinde her gece çalışan, projelerini ilerleten,
Telegram'a rapor gönderen bir agent sistemi kurar.

## Dosyalar
- `night-agent.yml` → her proje repo'suna konacak ana gece agent workflow'u
- `TASKS.md` → her proje repo'suna konacak görev şablonu
- `PROJECTS.md` → tüm projelerin merkezi kaydı (referans amaçlı, herhangi bir repoda tutulabilir)
- `TELEGRAM-KURULUM.md` → Telegram bot kurulum adımları
- `trend-scout.yml` → (opsiyonel) haftalık trend takibi + proje önerisi

## Adım Adım Kurulum

### 1. Anthropic API Key
https://console.anthropic.com üzerinden bir key oluştur.

### 2. Telegram Bot
`TELEGRAM-KURULUM.md` dosyasındaki adımları takip et (bot oluşturma + chat id bulma).

### 3. Her Proje İçin (lifesycle-live, microsoft, degenslide, trendai, sharesfor, whitegrave...)

```bash
cd proje-klasoru
mkdir -p .github/workflows
cp night-agent.yml .github/workflows/night-agent.yml
cp TASKS.md ./TASKS.md   # sonra projeye göre düzenle
git add .github/workflows/night-agent.yml TASKS.md
git commit -m "Gece agent kurulumu"
git push
```

Sonra GitHub'da repo → **Settings → Secrets and variables → Actions** → şu 3 secret'ı ekle:
- `ANTHROPIC_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

(Bot ve token tüm projelerde aynı olabilir — tek bot, çoklu proje.)

### 4. TASKS.md'yi Doldur
Her proje kendine özgü olduğu için `TASKS.md`'deki "Yapılacaklar" ve
"Kesinlikle Yapma" listelerini o projeye göre düzenle. Boş/genel bırakırsan
agent ne yapacağını kendi tahmin etmeye çalışır — bu risklidir.

### 5. Merkezi Kaydı Güncelle
`PROJECTS.md`'yi (istediğin bir repoda, ör. "personal" reposunda) tut,
yeni proje ekledikçe satır ekle.

### 6. Test Et
Actions sekmesi → workflow → **Run workflow** ile elle tetikleyip Telegram'a
mesaj geldiğini doğrula.

### 7. (Opsiyonel) Trend Tarayıcı
`trend-scout.yml`'i bir repoya koy (aynı secret'lar), haftada bir sana yeni
proje fikirleri gelsin.

## Günlük Akış
1. Gece 03:00 civarı her proje kendi workflow'unu çalıştırır.
2. Agent `TASKS.md`'deki işleri yapar, ayrı bir branch'te commit'ler.
3. Değişiklik varsa PR açar (ana branch'e asla direkt yazmaz).
4. Telegram'a kısa bir özet gelir: ne yapıldı, ne yapılamadı, onay bekleyen ne var.
5. Sabah sen PR'ları GitHub'dan incele, uygun olanları merge et.

## Sonraki Adımlar (İstediğinde)
- Diğer agent'lar (Ders, Yazılım Öğretmeni, Yarışma, Dil, Finans, Haberler)
  aynı GitHub Actions + Telegram mantığıyla ayrı ayrı kurulabilir.
- İleride hepsini tek yerden gösteren bir dashboard (agent'ların "masada
  oturduğu" görsel arayüz) ayrı bir proje olarak ele alınabilir.
