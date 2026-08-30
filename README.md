# Geometrik

LGS ve YKS (TYT + AYT) geometri konularını adım adım açılan, izlenebilir/durdurulabilir animasyonlarla anlatan bir iOS uygulaması. Soru çözme/AI özelliği **yok** - bilinçli bir tercih (bkz. konuşma geçmişi: Apple'ın "AI study-helper" doymuş kategori riski ve rakip yoğunluğu). Ürün, bir çözücü değil bir öğretmen.

Bu proje **Windows üzerinde tamamen yazıldı**; iOS uygulamaları yalnızca Mac + Xcode'da derlenebildiği için gerçek derleme/çalıştırma doğrulaması aşağıdaki Mac'siz TestFlight akışıyla yapılmalı (Kozmika ve Impulse_Buy_Gatekeeper projelerinde kanıtlanmış aynı yöntem).

## Mimari

- **Tamamen yerel** - sunucu/backend yok. Tüm ders içeriği (`Sources/Content/`) uygulamanın içine gömülü Swift verisi.
- **SwiftData + CloudKit (`.automatic`)** - ders ilerlemesi kullanıcının kendi iCloud hesabında saklanır/senkronize olur, ayrı bir hesap sistemi yok.
- **RevenueCat** - abonelik (freemium: her iki modülde ilk birkaç konu ücretsiz, gerisi abonelik).
- **XcodeGen** (`project.yml`) - `.xcodeproj` commit edilmez, her derlemede `xcodegen generate` ile üretilir.
- **Özel animasyon motoru** (`Sources/Engine/`) - dış kütüphane yok, tamamen native SwiftUI `Path`/`.trim`. Bir ders, `[GeometryStep]` dizisidir (nokta ekle, doğru çiz, yay çiz, etiket göster, vurgula) - yeni ders eklemek yeni kod değil yeni veri demektir.

## Kurulum (Mac üzerinde, tek seferlik)

1. Xcode 15+ kur.
2. `brew install xcodegen`
3. `xcodegen generate`
4. `Geometrik.xcodeproj`'u aç, Signing & Capabilities'te Team'i seç (zaten `project.yml`'de `R6W7XU4TM7` ayarlı).
5. Bir Simulator seç, ⌘R.

## Mac'siz test (önerilen): GitHub Actions + TestFlight

`.github/workflows/release-testflight.yml`, gerçek Xcode + App Store Connect API key ile otomatik imzalayıp doğrudan TestFlight'a yüklüyor (Kozmika'da yaşanan p12/provisioning-profile acılarının hiçbiri yok - `-allowProvisioningUpdates` ile Apple'ın kendi API'si provizyonu hallediyor).

**Tek seferlik kurulum:**
1. Bu Apple Developer hesabında (Team `R6W7XU4TM7`) `com.geometrikapp.app` bundle ID'siyle App Store Connect'te "Geometrik" adında bir uygulama kaydı aç.
2. **YENİ** bir Distribution sertifikası üret (Kozmika'nın sertifikaları farklı bir bundle ID/proje için - burada kullanılamaz). `-legacy` p12 export deseni (Kozmika oturumunda öğrenilen) ve `gh secret set` ile aktarım kullanılmalı.
3. **YENİ** bir App Store Connect API key üret (App Manager rolü).
4. GitHub reposuna şu secret'ları ekle:
   - `CERT_DIST_P12_BASE64`, `CERT_P12_PASSWORD` (yeni, bu proje için üretilen Distribution sertifikası)
   - `ASC_API_KEY_P8`, `ASC_KEY_ID`, `ASC_ISSUER_ID` (yeni API key)
5. GitHub → Actions → "Release to TestFlight" → Run workflow.

## RevenueCat kurulumu

`Sources/App/AppConfig.swift`'teki `revenueCatApiKey` placeholder - Kozmika'da izlenen adımların aynısı (RevenueCat projesi oluştur, App Store Connect'e bağla, `com.geometrikapp.app.premium.monthly`/`.yearly` ürünlerini App Store Connect'te oluşturup RevenueCat'e import et, entitlement + offering kur, gerçek `appl_` key'i buraya yapıştır).

## GitHub Pages (Gizlilik/Kullanım Şartları/Destek)

`docs/` klasöründeki `privacy.html`, `terms.html`, `support.html` - repo'da **Settings → Pages → Source: Deploy from branch → main → /docs** ile yayınlanır. `Sources/Features/Settings/SettingsView.swift`'teki linkler `https://<github-kullanıcı-adı>.github.io/<repo-adı>/...` formatını varsayıyor - gerçek repo adı farklıysa bu linkleri güncelle.

## İçerik durumu

- **Tam animasyonlu (motor doğrulaması için)**: LGS → Üçgenin Temel Elemanları, Pisagor Bağıntısı
- **Placeholder ("yakında")**: kalan 4 LGS + 11 YKS konusu - `Sources/Content/PlaceholderLesson.swift` deseniyle, gerçek içerikle değiştirilmeyi bekliyor
- Yeni bir ders eklemek: `Sources/Content/LGS/` veya `YKS/` altına yeni bir `enum XyzLesson { static let lesson = Lesson(steps: [...], comprehensionCheck: [...]) }` dosyası + ilgili `LGSContent.swift`/`YKSContent.swift`'teki placeholder satırını gerçek lesson ile değiştirmek.

## Bilinen eksikler

- **App Icon**: placeholder/boş, 1024×1024 bir görsel eklenmeli.
- **Sağ açı işareti** (Pisagor dersinde): şu an küçük bir yay ile gösteriliyor, gerçek bir kare işareti (⌐ tarzı) değil - kozmetik bir iyileştirme.
- Kapsam dışı: Apple Watch, offline içerik indirme, gerçek analitik.
