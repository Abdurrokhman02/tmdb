// lib/movie_model.dart

class Movie {
  final String title;
  final String overview;
  final String posterPath; // Ini isinya cuma nama file/hash, belum URL lengkap

  // Constructor
  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  // Factory Method untuk Parsing JSON
  // Ini adalah bagian inti untuk mengubah data Map (JSON) menjadi objek Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    // URL dasar gambar dari TMDb
    const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

    // Ambil data dan gabungkan poster_path
    // Jika poster_path null, kita beri string kosong/default
    final String fullPosterPath = json['poster_path'] != null
        ? '$baseImageUrl${json['poster_path']}'
        : ''; // Memberikan string kosong kalau null

    return Movie(
      title: json['title'] ?? 'Judul Tidak Tersedia', // Pakai ?? untuk jaga-jaga kalau data null
      overview: json['overview'] ?? 'Deskripsi tidak tersedia.',
      posterPath: fullPosterPath, // Ini sudah URL lengkap
    );
  }
}