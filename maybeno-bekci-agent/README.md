# maybeno-bekci-agent — Bekçi (Gözetmen) Ajan

**Amacı:** Bu repo altındaki tüm diğer ajanları (`maybeno-ders-agent`,
`maybeno-finans-agent`, `maybeno-ingilizce-agent`, `maybeno-tech-haber`,
`maybeno-yarisma-agent`, `maybeno-yazilim-ogretmen`) denetler. Kod
üretmez, içerik üretmez — sadece diğer ajanların **anayasa.md'ye uygun
çalışıp çalışmadığını** ve **hafıza dosyalarının sağlığını** kontrol eder.

Bekçi de bir ajandır: çalışmaya başlamadan önce o da `anayasa.md` →
`KIMLIK.md` → `HATA-DEFTERI.md` → `SKILLS.md` sırasını takip eder.

## Ne Kontrol Eder

1. **Anayasa ihlali:** Her ajanın son commit'lerine bakar — main'e
   bellek-dışı dosya (kod, README, workflow) doğrudan push edilmiş mi,
   `.env`/secret içeren bir dosya commit'lenmiş mi.
2. **Defter sağlığı:** Her ajanın `HATA-DEFTERI.md` dosyası ~200 satırı
   geçmiş mi, geçmişse rotasyon (bkz. `anayasa.md` §4) yapılmış mı;
   yapılmadıysa kendisi rotasyonu tamamlar.
3. **Eksik dosya:** Her ajan klasöründe zorunlu dosyalar
   (`KIMLIK.md`, `HATA-DEFTERI.md`, `SKILLS.md`, `hata-arsivi/`) var mı.
4. **Workflow sağlığı:** `gh run list` ile son çalışmaların başarılı olup
   olmadığına bakar (opsiyonel, `gh` CLI erişimi varsa).

## Çıktı

Haftalık tek bir Telegram raporu: ajan başına 1 satır durum
(✅ sorun yok / ⚠️ dikkat / 🚫 ihlal) + varsa detay. İhlal bulursa
kendi `HATA-DEFTERI.md`'sine de kaydeder.

## Dosyalar

- `KIMLIK.md` — bekçinin kimliği ve sınırları
- `HATA-DEFTERI.md` — bekçinin kendi hata/ders defteri
- `SKILLS.md` — bekçinin kendi geliştirdiği kontrol kısayolları
- `hata-arsivi/` — rotasyondan çıkan özet dosyalar
- `.github/workflows/bekci-denetim.yml` — haftalık denetim workflow'u

## Kesin Sınır

Bekçi hiçbir ajanın kod/içerik dosyasına **müdahale etmez**, sadece
okur ve raporlar. Kendi bellek dosyaları dışında hiçbir şeyi commit'lemez
(bkz. `anayasa.md` §1 — "başka bir ajanın klasörüne izinsiz yazma").
