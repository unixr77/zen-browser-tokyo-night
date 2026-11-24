# zen-browser-tokyo-night
Tokyo Night Theme for Zen Browser


Otomatik kurulum

Zen'i tamamen kapat.
Üç dosyanın bulunduğu klasörde bash install.sh çalıştır.
Zen'i aç.

Betik profiles.ini üzerinden profili buluyor, mevcut userChrome.css/userContent.css dosyalarını .bak-tarih olarak yedekliyor ve gerekli tercihi user.js'e yazıyor. Profili bulamazsa ZEN_PROFILE="/profil/yolu" bash install.sh ile elle verebilirsin.

Elle kurulum

Zen'de about:config aç, toolkit.legacyUserProfileCustomizations.stylesheets değerini true yap.
about:profiles sayfasında "Root Directory" yanındaki "Open Directory" ile profil klasörünü aç. CachyOS'ta genelde ~/.config/zen/<profil> ya da ~/.zen/<profil> olur.
Orada chrome adında bir klasör oluştur, userChrome.css ile userContent.css dosyalarını içine kopyala.
Zen'i tamamen kapatıp yeniden aç.
Zen'in görünümünün koyu modda (veya sistem koyuysa Otomatik) olduğundan emin ol. Tema yalnızca koyu modda uygulanıyor.
