# maybeno-agent

MYBENNO / MAYBINLO için kurulan ilk agent: **Proje Yönetim Agent'ı**.
Diğer agent'lar (Ders, Yazılım Öğretmeni, Yarışma, Dil, Finans, Haberler)
aynı yapı üzerine ileride eklenecek.

## Bu Repo Ne Yapar
Bu repo, GitHub Actions üzerinden her gece otomatik çalışan bir Claude Code
agent'ı barındırır. Agent:
1. `TASKS.md`'deki görevleri okur
2. Kod üzerinde çalışır (ayrı branch'te)
3. Değişiklik varsa PR açar
4. Telegram'a özet rapor gönderir

## Klasör Yapısı
```
.github/workflows/
  night-agent.yml     → her gece çalışan ana agent
  trend-scout.yml      → (opsiyonel) haftalık trend/proje fikri taraması
TASKS.md                → agent'ın bu repoda yapacağı işler
PROJECTS.md              → takip edilen tüm projelerin merkezi kaydı
TELEGRAM-KURULUM.md      → Telegram bot kurulum adımları
KURULUM.md                → tam kurulum talimatı (bu dosyayı takip et)
```

## Önemli Not — Çoklu Proje Yaklaşımı
Şu an takip edilen projeler (lifesycle-live, microsoft, degenslide, trendai,
sharesfor, whitegrave) **ayrı repo'lar**. GitHub Actions her repo kendi
içinde çalışır, başka bir repo'ya otomatik erişemez. Bu yüzden iki seçenek var:

**Seçenek A (basit, önerilen başlangıç):** `.github/workflows/night-agent.yml`
dosyasını her proje repo'suna ayrı ayrı kopyala. Bu repo (`maybeno-agent`)
şablon/merkez görevi görür, `PROJECTS.md` üzerinden hangi projede ne durumda
olduğunu takip edersin.

**Seçenek B (ileri seviye):** `maybeno-agent` merkezi bir "orkestratör"
olur — her proje repo'suna `repository_dispatch` ile sinyal gönderir, onlar
çalışır, sonuçları tekrar buraya bildirir. Bunu ilk kurulum stabil
çalıştıktan sonra konuşalım, şimdi gereksiz karmaşıklık.

Claude Code'u bu repo'da açtığında ona söyleyebileceğin ilk komut:

> "TASKS.md ve KURULUM.md dosyalarını oku. Şu an bu repo'da ne eksik,
> bir sonraki adımda ne yapmam gerekiyor, sırayla anlat."
