# Obsidian Kurulumu (Ajan Belleğini Görselleştirmek İçin)

Bu repo'daki her ajan hafızasını düz Markdown dosyalarında tutuyor
(`HATA-DEFTERI.md`, `SKILLS.md`, `TASKS.md`, `PROJECTS.md`, ders/finans
takip dosyaları vb.). Obsidian bu dosyalara dokunmadan, üzerine bir
okuma/graph/sorgu katmanı ekliyor.

## 1. Repo'yu Vault Olarak Aç

1. Obsidian'ı aç → **Open folder as vault**.
2. Bu repo'nun kök klasörünü seç (bu dosyanın bulunduğu klasör).
3. Hiçbir dönüşüm gerekmiyor — tüm `.md` dosyaları otomatik not olarak
   görünür (agent klasörleri de dahil: `maybeno-ders-agent/`,
   `maybeno-finans-agent/` vb.).

## 2. Obsidian Git Plugin'i Kur (Otomatik Senkron)

Ajanlar gece boyunca commit atıyor; bunları Obsidian'a otomatik çekmek için:

1. **Settings → Community plugins → Browse** → "Obsidian Git" ara, kur, etkinleştir.
2. Plugin ayarlarında:
   - **Vault backup interval**: 0 kapalı bırakılabilir (ajanlar zaten commit atıyor).
   - **Auto pull interval**: 30-60 dakika öner (gece atılan commit'leri sabah görürsün).
   - **Auto push**: Sadece kendi elle not eklediğin durumlarda aç; kapalıysa
     commit/push'u Command Palette'ten (`Ctrl+P` → "Git: Commit and push") elle tetikleyebilirsin.
3. İlk kurulumda vault'un zaten bu repo'nun git klasörü olduğu için ekstra
   `git init` gerekmez.

**Çakışma riski:** Ajanlar `HATA-DEFTERI.md` / `SKILLS.md` / `hata-arsivi/*`
dosyalarına doğrudan `main`'e push atıyor (bkz. `anayasa.md` §3). Sen de o
dosyalarda not tutuyorsan pull/push sırasında çakışma çıkabilir. Bunu
önlemek için o dosyalara elle not eklemek istersen "Auto pull" aç,
"Auto push"u kapalı tut ve pull edip görmeden not eklemeye başlama.

## 3. Dataview Plugin'i Kur (Sorgu/Dashboard)

1. **Settings → Community plugins → Browse** → "Dataview" ara, kur, etkinleştir.
2. Bununla, örneğin "tüm ajanlardaki son hatalar" gibi otomatik bir liste
   kurmak için yeni bir not açıp şunu yazabilirsin:

```dataview
list
from "maybeno-ders-agent" or "maybeno-finans-agent" or "maybeno-ingilizce-agent" or "maybeno-tech-haber" or "maybeno-yarisma-agent" or "maybeno-yazilim-ogretmen" or "maybeno-bekci-agent"
where contains(file.name, "HATA-DEFTERI")
```

Daha ayrıntılı filtreleme (tarihe göre, ajana göre) için dosyalara YAML
frontmatter eklemek gerekir — bkz. aşağıdaki "Frontmatter Önerisi".

## 4. Frontmatter Önerisi (Opsiyonel, Dataview'i Güçlendirir)

Şu an ajan dosyaları düz Markdown; frontmatter yok. Eklemek istersen her
ajanın `HATA-DEFTERI.md` / `SKILLS.md` dosyasının en üstüne şunu ekleyebilirsin:

```yaml
---
agent: maybeno-ders-agent
type: hata-defteri
---
```

Bunu eklemek `anayasa.md`'deki format/rotasyon kurallarını bozmaz (dosya
içeriği aynı kalır, sadece başa metadata eklenir). Ancak bu bir kod
değişikliği olduğu için `anayasa.md` §3'e göre bellek dosyaları dışındaki
her şey PR ile gitmeli — frontmatter eklemek istersen ayrı bir PR aç,
ajan workflow prompt'larına da "frontmatter'ı koru, HATA-DEFTERI'ye eklerken
frontmatter bloğunun altına ekle" talimatı ekle (yoksa bir ajan bir gün
frontmatter'ı silebilir).

## 5. Graph View ile İlişkileri Görmek

Ajan dosyaları arasında gerçek `[[wikilink]]` yoksa graph view'da hepsi
kopuk noktalar olarak görünür. İstersen ilgili notlar arasında elle bağlantı
kurabilirsin (örn. `PROJECT-IDEAS.md`'deki bir fikri `PROJECTS.md`'deki
satıra `[[PROJECTS#lifesycle-live]]` gibi bağlamak). Bunu ajanlara
otomatik yaptırmak istersen `anayasa.md`'ye bir kural eklemek gerekir —
şu an bu repo'da böyle bir zorunluluk yok.

## 6. Mobil / Diğer Cihazlar

Obsidian Git plugin mobilde de çalışıyor ama arka planda otomatik
pull/push için ek ayar (Termux/iOS kısıtları) gerekebilir. En basit yol:
masaüstünde Obsidian + Obsidian Git kullan, mobilde sadece görüntülemek
istiyorsan Obsidian Sync (ücretli) veya iCloud/Syncthing ile klasörü
paylaş.
