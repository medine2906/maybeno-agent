# Telegram Bot Kurulumu (Rapor Bildirimleri İçin)

## 1. Bot Oluştur
1. Telegram'da **@BotFather**'ı bul, `/start` yaz.
2. `/newbot` komutunu gönder, bot'a bir isim ve kullanıcı adı ver
   (ör. isim: "Proje Yönetim Agent", kullanıcı adı: `senin_proje_agent_bot`).
3. BotFather sana bir **token** verecek — şuna benzer:
   `123456789:AAExxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   Bunu kaydet, bu `TELEGRAM_BOT_TOKEN` olacak.

## 2. Chat ID'ni Bul
1. Telegram'da yeni oluşturduğun bota git, ona herhangi bir mesaj gönder (ör. "merhaba").
2. Tarayıcıdan şu adresi aç (TOKEN yerine kendi token'ını yaz):
   `https://api.telegram.org/botTOKEN/getUpdates`
3. Dönen JSON içinde `"chat":{"id": 123456789, ...}` kısmındaki sayı senin
   `TELEGRAM_CHAT_ID`'n.

## 3. GitHub Secrets'a Ekle
Rapor almak istediğin HER repo için:
- **Settings → Secrets and variables → Actions → New repository secret**
- `TELEGRAM_BOT_TOKEN` → aldığın token
- `TELEGRAM_CHAT_ID` → bulduğun chat id

(Aynı token/chat id'yi tüm projelerde kullanabilirsin — bot tek, projeler çok.)

## 4. Test Et
Kurulumdan sonra bir workflow'u elle tetikle (Actions → Run workflow).
Çalışma bitince Telegram'da bottan bir mesaj gelmeli. Gelmezse:
- Secret isimlerini kontrol et (birebir aynı olmalı: `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`)
- Bota önceden bir mesaj gönderdiğinden emin ol (bot sana mesaj atmadan önce
  senin ona bir kere yazmış olman gerekiyor)
