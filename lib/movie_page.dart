// lib/movie_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'movie_model.dart'; // Import model yang sudah kita buat

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  // GANTI dengan API Key TMDb kamu!
  // Ambil dari .env file menggunakan dotenv
  late final String apiKey = dotenv.env['TMDB_API_KEY'] ?? 'API_KEY_ANDA';
  
  // URL Endpoint Now Playing
  late final String apiUrl =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey';

  // Future untuk menampung hasil pengambilan data
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovies();
  }

  // Fungsi untuk mengambil data film dari API
  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // 1. Decode body response menjadi Map
      final Map<String, dynamic> data = json.decode(response.body);

      // 2. TMDb menyimpan daftar film di dalam list bernama 'results'
      final List<dynamic> results = data['results'];

      // 3. Mapping setiap item di 'results' ke objek Movie
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      // Jika respons gagal, lempar error
      throw Exception('Gagal mengambil data film. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sedang Tayang (Now Playing)'),
        backgroundColor: Colors.indigo,
      ),
      // FutureBuilder akan menunggu _moviesFuture selesai
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading saat data masih diambil
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan pesan error jika ada masalah
            return Center(child: Text('Ups, ada error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Data berhasil diambil dan tidak kosong
            final List<Movie> movies = snapshot.data!;
            
            // --- Langkah 6: Tampilkan Data ---
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    // Tampilkan Gambar Poster (poster_path)
                    leading: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        // Gunakan Image.network hanya jika posterPath tidak kosong
                        image: movie.posterPath.isNotEmpty 
                            ? DecorationImage(
                                image: NetworkImage(movie.posterPath),
                                fit: BoxFit.cover,
                              )
                            : null, // Jika kosong, biarkan kosong
                        color: movie.posterPath.isEmpty ? Colors.grey[300] : null,
                      ),
                      child: movie.posterPath.isEmpty 
                          ? const Icon(Icons.movie, color: Colors.white) 
                          : null,
                    ),

                    // Tampilkan Judul Film (title)
                    title: Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    
                    // Tampilkan Deskripsi Singkat (overview)
                    subtitle: Text(
                      movie.overview,
                      maxLines: 3, // Batasi teks agar tidak terlalu panjang
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
            // --- Akhir Langkah 6 ---

          } else {
            // Jika data kosong
            return const Center(child: Text('Tidak ada film yang sedang tayang saat ini.'));
          }
        },
      ),
    );
  }
}

// Jangan lupa set MoviePage sebagai home di main.dart
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TMDb App',
      home: MoviePage(), // <--- Panggil halaman ini
    );
  }
}
*/