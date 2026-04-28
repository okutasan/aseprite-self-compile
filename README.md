# Aseprite Docker Builder 🎨

> [!CAUTION]
> **⚖️ PENTING: Mengenai Lisensi & Etika**
>
> Proyek ini **tidak** menyertakan file binary Aseprite. Sesuai dengan lisensi EULA Aseprite:
>
> - ✅ **Boleh**: Mengunduh source code dan compile sendiri untuk penggunaan pribadi.
> - ❌ **Tidak Boleh**: Membagikan ulang hasil kompilasi (binary) ke orang lain.
>
> Jadi, repo ini cuma menyediakan "resep" (Dockerfile) supaya kamu bisa build sendiri dengan mudah. Dukung terus developer aslinya dengan mematuhi lisensi ini ya! 🤝

Repo ini dibuat untuk memudahkan kamu melakukan kompilasi [Aseprite](https://github.com/aseprite/aseprite) dari *source code* secara otomatis menggunakan **Docker**.

Dengan cara ini, kamu bisa punya *portable binary* Aseprite untuk Linux tanpa perlu mengotori sistem utama dengan puluhan *build tools* dan *dependencies*.

## 🚀 Fitur

- **Clean Build**: Semua proses kompilasi berjalan di dalam container Ubuntu 22.04 yang terisolasi.
- **Automated**: Script ini otomatis mengunduh Aseprite v1.3.17 dan Skia yang dibutuhkan.
- **Portable**: Hasil akhirnya berupa file `.tar.gz` yang bisa langsung kamu jalankan di distro Linux mana saja.

## 📋 Prasyarat

- Sudah terinstall [Docker](https://docs.docker.com/get-docker/).
- RAM minimal 4GB (disarankan 8GB+ biar proses build-nya lebih ngebut).

## 🛠️ Cara Build

1. **Clone Repo:**

   ```bash
   git clone https://github.com/okutasan/aseprite-self-compile.git
   cd aseprite-self-compile
   ```

2. **Jalankan Build:**

   Gunakan flag `--cpus` kalau kamu mau membatasi penggunaan core CPU supaya PC nggak *freeze*. Contoh kalau mau pakai 4 core:

   ```bash
   docker build --cpus="4.0" -t aseprite-builder .
   ```

3. **Ambil Binary-nya:**

   Setelah build selesai, ambil file `.tar.gz` dari dalam container:

   ```bash
   docker create --name extractor aseprite-builder
   docker cp extractor:/build/aseprite-portable-linux.tar.gz .
   docker rm extractor
   ```

## 🏃 Cara Menjalankan

Ekstrak file yang sudah diambil tadi:

```bash
mkdir -p ~/Aseprite
tar -xzvf aseprite-portable-linux.tar.gz -C ~/Aseprite
```

Lalu jalankan aplikasinya:

```bash
~/Aseprite/aseprite
```

## 🔄 Cara Update Versi

Jika Aseprite merilis versi baru, kamu bisa mengupdate `Dockerfile` secara manual:

1. Buka file `Dockerfile`.
2. Ubah `ASEPRITE_VERSION` ke versi terbaru (contoh: `v1.3.18`).
3. Sesuaikan `SKIA_VERSION` jika diperlukan (lihat dokumentasi Aseprite).
4. Jalankan ulang proses build.

## 📄 Lisensi

Dockerfile dan instruksi dalam repositori ini dilisensikan di bawah **MIT License**. Lihat file [LICENSE](LICENSE) untuk detailnya.

---
Dibuat dengan ❤️ oleh [okutasan](https://github.com/okutasan)
