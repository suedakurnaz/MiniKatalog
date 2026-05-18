# Mini Katalog - Flutter Uygulaması

Flutter eğitimi sonunda yapılması gereken Mini Katalog projesi.

## Kurulum

### Adım 1: Zip'i aç
ZIP dosyasını bir klasöre çıkar, adı `mini_katalog` olsun.

### Adım 2: VS Code'da aç
VS Code'u aç → File → Open Folder → `mini_katalog` klasörünü seç.

### Adım 3: Terminali aç
VS Code'da Terminal → New Terminal

### Adım 4: Flutter iskeletini oluştur
```bash
flutter create .
```
Bu komut iOS ve Android klasörlerini tamamlar. Mevcut koduna dokunmaz.

### Adım 5: Paketleri yükle
```bash
flutter pub get
```

### Adım 6: Çalıştır
```bash
flutter run
```

## Özellikler

- **Ana Sayfa**: Animasyonlu karşılama, banner, kategori kartları
- **Ürün Listesi**: 30 ürün (DummyJSON API), GridView, arama, kategori filtresi
- **Ürün Detayı**: Görsel, açıklama, puan, stok bilgisi
- **Sepet**: Bottom sheet, ürün ekleme/çıkarma, toplam, sipariş ver

## Teknik Detaylar

- Flutter 3.x
- http paketi ile API çağrısı
- StatefulWidget + setState
- Navigator.push / Navigator.pop
- GridView.builder + ListView.builder
- fromJson model
- API: https://dummyjson.com/products
