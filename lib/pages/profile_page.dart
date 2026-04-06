import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'login_page.dart';

class WeatherPage extends StatefulWidget {
  final String username;
  const WeatherPage({super.key, required this.username});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? weatherData;
  
  // Koordinat default (Wonosobo)
  LatLng currentLatLng = const LatLng(-7.3633, 109.9003);
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    fetchWeatherData(currentLatLng.latitude, currentLatLng.longitude);
  }

  Future<void> fetchWeatherData(double lat, double lon) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Asia%2FJakarta');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data cuaca.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Kesalahan jaringan: $e';
        isLoading = false;
      });
    }
  }

  String getWeatherDescription(int code) {
    switch (code) {
      case 0: return 'Cerah';
      case 1: case 2: return 'Cerah Berawan';
      case 3: return 'Mendung';
      case 45: case 48: return 'Berkabut';
      case 51: case 53: case 55: return 'Gerimis';
      case 61: case 63: case 65: return 'Hujan';
      case 80: case 81: case 82: return 'Hujan Deras';
      case 95: case 96: case 99: return 'Badai Petir';
      default: return 'Lainnya';
    }
  }

  IconData getWeatherIcon(int code) {
    switch (code) {
      case 0: return Icons.wb_sunny_rounded;
      case 1: case 2: return Icons.wb_cloudy_rounded;
      case 3: return Icons.cloud_rounded;
      case 45: case 48: return Icons.blur_on_rounded;
      case 51: case 53: case 55: return Icons.grain_rounded;
      case 61: case 63: case 65: return Icons.umbrella_rounded;
      case 80: case 81: case 82: return Icons.tsunami_rounded;
      case 95: case 96: case 99: return Icons.flash_on_rounded;
      default: return Icons.help_outline_rounded;
    }
  }

  String getDayName(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'][date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Weather Explorer', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(currentLatLng, 13.0);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade900, Colors.blue.shade600, Colors.lightBlue.shade300],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 30),
            
            // MAP SECTION DENGAN CARD STYLE
            _buildMapSection(),

            // WEATHER DATA SECTION
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _buildWeatherContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: currentLatLng,
            initialZoom: 11.0,
            onTap: (tapPosition, latLng) {
              setState(() => currentLatLng = latLng);
              fetchWeatherData(latLng.latitude, latLng.longitude);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', // Theme map lebih berwarna
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLatLng,
                  width: 60,
                  height: 60,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: const Icon(Icons.location_pin, color: Colors.redAccent, size: 50),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)));
    }

    final current = weatherData!['current'];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Header Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lokasi Terpilih", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(
                    "${currentLatLng.latitude.toStringAsFixed(2)}, ${currentLatLng.longitude.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                child: const Text("Live", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 30),

          // Main Temp Card
          _buildGlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(getWeatherIcon(current['weather_code']), size: 80, color: Colors.white),
                Column(
                  children: [
                    Text(
                      '${current['temperature_2m'].round()}°',
                      style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      getWeatherDescription(current['weather_code']),
                      style: const TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Details Row
          Row(
            children: [
              Expanded(child: _buildDetailItem(Icons.water_drop_outlined, "Humidity", "${current['relative_humidity_2m']}%")),
              const SizedBox(width: 15),
              Expanded(child: _buildDetailItem(Icons.air_rounded, "Wind", "${current['wind_speed_10m']} km/h")),
            ],
          ),
          const SizedBox(height: 30),

          // Forecast
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("7-Day Forecast", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          _buildForecastList(),
          
          const SizedBox(height: 30),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildForecastList() {
    final daily = weatherData!['daily'];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daily['time'].length,
        itemBuilder: (context, index) {
          return Container(
            width: 85,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.white24 : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getDayName(daily['time'][index]), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Icon(getWeatherIcon(daily['weather_code'][index]), color: Colors.white, size: 28),
                const SizedBox(height: 8),
                Text('${daily['temperature_2m_max'][index].round()}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Text("LOGOUT SESSION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ),
    );
  }
}