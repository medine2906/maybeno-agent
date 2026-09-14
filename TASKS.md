# Gece Agent Görev Listesi

Bu dosyayı her repo'nun kök dizinine koy. Agent her gece bu dosyayı okuyup
buradaki talimatlara göre çalışır. Ne kadar net yazarsan, o kadar isabetli
çalışır.

## Yapılacaklar
- [ ] Örnek: Açık issue'ları listele, basit olanları (typo, ufak bug) çöz
- [ ] Örnek: Testleri çalıştır, kırık olanları düzelt
- [ ] Örnek: TODO yorumlarını tara, uygun olanları uygula
- [ ] Örnek: Bağımlılıkları kontrol et, güvenlik açığı varsa raporla (güncelleme YAPMA)

## Kesinlikle Yapma
- Ana branch'e (main/master) doğrudan push/merge yapma
- Migration veya veri silme işlemi yapma
- .env, secrets, API key içeren dosyalara dokunma
- Yeni bağımlılık ekleme (önce PR'da öner, otomatik ekleme)
- Production'a deploy tetikleme

## Çalışma Şekli
- Her değişikliği ayrı, açıklayıcı commit mesajlarıyla yap
- İşin sonunda bir özet yaz: ne yapıldı, ne yapılamadı, neden
- Emin olmadığın kararlarda değişiklik yapmak yerine yorum/not bırak

## Notlar
(Buraya proje-özel bağlam, kod stili tercihleri, mimari kurallar ekleyebilirsin.)
