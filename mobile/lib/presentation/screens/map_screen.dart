import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../widgets/noise_measurement_modal.dart';
import '../../domain/models/noise_measurement.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _userLatLng;
  Marker? _userMarker;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(0.0, 0.0), // Will be updated to user location
    zoom: 14.0,
  );

  // Demo measurement data points
  final List<MeasurementPoint> _measurementPoints = [
    MeasurementPoint(
      id: '1',
      latitude: 40.7589,
      longitude: -73.9851,
      decibelLevel: 38.0,
      venueName: 'Central Park Library',
      venueType: 'Library',
    ),
    MeasurementPoint(
      id: '2',
      latitude: 40.7614,
      longitude: -73.9776,
      decibelLevel: 65.0,
      venueName: 'Times Square Cafe',
      venueType: 'Restaurant',
    ),
    MeasurementPoint(
      id: '3',
      latitude: 40.7505,
      longitude: -73.9934,
      decibelLevel: 34.0,
      venueName: 'Quiet Study Hall',
      venueType: 'Library',
    ),
    MeasurementPoint(
      id: '4',
      latitude: 40.7549,
      longitude: -73.9840,
      decibelLevel: 35.0,
      venueName: 'Bryant Park Reading Room',
      venueType: 'Library',
    ),
    MeasurementPoint(
      id: '5',
      latitude: 40.7580,
      longitude: -73.9855,
      decibelLevel: 45.0,
      venueName: 'Midtown Coffee Shop',
      venueType: 'Cafe',
    ),
    MeasurementPoint(
      id: '6',
      latitude: 40.7527,
      longitude: -73.9772,
      decibelLevel: 41.0,
      venueName: 'Herald Square Bookstore',
      venueType: 'Retail',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initLocation();
    _loadRealMeasurements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Services disabled; we won't block, but we won't show a user marker
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          // timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      final userLatLng = LatLng(position.latitude, position.longitude);
      final userMarker = Marker(
        markerId: const MarkerId('user'),
        position: userLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      );

      setState(() {
        _userLatLng = userLatLng;
        _userMarker = userMarker;
      });

      // Animate camera to user's current location
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLatLng, zoom: 15.0),
        ),
      );

      // Generate demo points around the user's current location with a wide perimeter
      _generateDemoPoints(userLatLng);
    } catch (e) {
      // Swallow errors silently for now; can add logging/snackbar if desired
    }
  }

  void _generateDemoPoints(LatLng center) {
    // Clear existing demo points and repopulate around the user's location
    _measurementPoints.clear();

    // Generate points on a wide ring around the user (roughly 1–4 km)
    // 1 degree latitude ~ 111 km; 0.01 deg ~ 1.11 km
    final random = math.Random();
    final venueTypes = ['Library', 'Cafe', 'Restaurant', 'Retail', 'Park'];
    final venueNames = [
      'Quiet Nook',
      'City Library',
      'Corner Cafe',
      'Urban Eatery',
      'Central Park',
      'Riverside Cafe',
      'Downtown Hub',
      'Book Haven',
      'Silent Study',
      'Green Plaza',
      'Zen Lounge',
      'Serenity Spot',
      'Market Square',
      'Harbor View',
      'Skyline Bar'
    ];

    // Create 24 points distributed around the user
    const int count = 24;
    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi / count) * i +
          random.nextDouble() * 0.2; // slight jitter
      final radiusDeg = 0.001 +
          random.nextDouble() * 0.03; // 0.01 - 0.04 degrees (~1.1 - 4.4 km)

      // Adjust lon by cos(latitude) factor for more accurate spacing
      final latOffset = radiusDeg * math.sin(angle);
      final lonOffset = (radiusDeg * math.cos(angle)) /
          math.cos(center.latitude * math.pi / 180);

      final lat = center.latitude + latOffset;
      final lon = center.longitude + lonOffset;

      final db = 30 + random.nextInt(50); // 30 - 79 dB
      final vt = venueTypes[random.nextInt(venueTypes.length)];
      final vn = venueNames[random.nextInt(venueNames.length)];

      _measurementPoints.add(MeasurementPoint(
        id: 'demo_${i + 1}',
        latitude: lat,
        longitude: lon,
        decibelLevel: db.toDouble(),
        venueName: vn,
        venueType: vt,
      ));
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Google Map
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                debugPrint('GoogleMap created successfully');
              },
              markers: _getAllMarkers(),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onTap: (LatLng location) {
                debugPrint(
                    'Map tapped at: ${location.latitude}, ${location.longitude}');
              },
            ),
          ),

          // Top UI Controls
          SafeArea(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  margin: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    indicatorPadding:
                        const EdgeInsets.all(AppConstants.paddingS - 3),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Measure'),
                      Tab(text: 'Explore'),
                    ],
                  ),
                ),

                // Search Bar
                AnimatedContainer(
                  duration: AppConstants.animationNormal,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search venue',
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {},
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingM,
                          vertical: AppConstants.paddingM,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Venue Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(AppConstants.paddingM),
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Venue',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Search venue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        _userLatLng != null ? _measureAtCurrentLocation : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _userLatLng != null
                            ? 'Tap to measure'
                            : 'Getting location...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _userLatLng != null
                              ? AppConstants.primaryColor
                              : AppConstants.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return _measurementPoints.map((point) {
      return Marker(
        markerId: MarkerId(point.id),
        position: LatLng(point.latitude, point.longitude),
        onTap: () => _showVenueDetails(point),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerHue(point.decibelLevel),
        ),
        infoWindow: InfoWindow(
          title: point.venueName,
          snippet: '${point.decibelLevel.toInt()} dB • ${point.venueType}',
        ),
      );
    }).toSet();
  }

  Set<Marker> _getAllMarkers() {
    var markers = _createMarkers();
    if (_userMarker != null) {
      markers = {...markers, _userMarker!};
    }
    return markers;
  }

  double _getMarkerHue(double decibelLevel) {
    if (decibelLevel < 40) return BitmapDescriptor.hueGreen;
    if (decibelLevel < 55) return BitmapDescriptor.hueYellow;
    if (decibelLevel < 70) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueRed;
  }

  void _showVenueDetails(MeasurementPoint point) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(AppConstants.paddingM),
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getNoiseColor(point.decibelLevel),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${point.decibelLevel.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.venueName,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${point.venueType} • ${point.decibelLevel} dB',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startMeasurementAtLocation(point);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Measure Here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNoiseColor(double decibelLevel) {
    if (decibelLevel < 40) return AppConstants.noiseQuiet;
    if (decibelLevel < 55) return AppConstants.noiseModerate;
    if (decibelLevel < 70) return AppConstants.noiseLoud;
    return AppConstants.noiseVeryLoud;
  }

  void _startMeasurementAtLocation(MeasurementPoint point) {
    // Show measurement type selection modal
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NoiseMeasurementModal(
        onTypeSelected: (type) async {
          Navigator.pop(context);
          await _beginRealMeasurementAtPoint(point, type);
        },
      ),
    );
  }

  Future<void> _beginRealMeasurementAtPoint(
      MeasurementPoint point, NoiseMeasurementType measurementType) async {
    try {
      // Show measurement in progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                  '🎙️ Measuring ${measurementType.name} at ${point.venueName}...'),
            ],
          ),
          backgroundColor: AppConstants.primaryTeal,
          duration: const Duration(seconds: 30),
        ),
      );

      // Start real measurement
      await ref.read(measurementStateProvider.notifier).startMeasurement();

      // Auto-stop after 30 seconds and update the map
      Future.delayed(const Duration(seconds: 30), () async {
        try {
          // Check if widget is still mounted and context is valid
          if (!mounted || !context.mounted) return;

          final measurementState = ref.read(measurementStateProvider);
          if (measurementState.isMeasuring) {
            ref.read(measurementStateProvider.notifier).stopMeasurement();

            // Calculate average and update map point
            if (measurementState.decibelHistory.isNotEmpty) {
              final averageDecibel =
                  measurementState.decibelHistory.reduce((a, b) => a + b) /
                      measurementState.decibelHistory.length;

              // Update this point with real measurement
              _updatePointWithRealMeasurement(
                  point, averageDecibel, measurementType.name);

              // Save measurement to database
              await _saveMapMeasurement(point, averageDecibel, measurementType);

              // If this is a user location measurement, add it to current location
              if (point.id == 'user_location') {
                _addRealTimeUserLocationMeasurement(averageDecibel);
              }

              // Show completion feedback with safe navigation check
              if (mounted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '✅ Real measurement complete: ${averageDecibel.toStringAsFixed(1)} dB'),
                    backgroundColor: AppConstants.successColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          }
        } catch (e) {
          debugPrint('Error in delayed measurement completion: $e');
          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('❌ Error completing measurement: ${e.toString()}'),
                backgroundColor: AppConstants.errorColor,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      });
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Measurement failed: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _updatePointWithRealMeasurement(
      MeasurementPoint point, double realDecibel, String measurementType) {
    setState(() {
      // Find and update the point
      for (int i = 0; i < _measurementPoints.length; i++) {
        if (_measurementPoints[i].id == point.id) {
          _measurementPoints[i] = MeasurementPoint(
            id: point.id,
            latitude: point.latitude,
            longitude: point.longitude,
            decibelLevel: realDecibel,
            venueName: '${point.venueName} (Real)',
            venueType: measurementType,
          );
          break;
        }
      }
    });
  }

  /// Add real-time measurement at user's current location
  void _addRealTimeUserLocationMeasurement(double decibelLevel) {
    if (_userLatLng != null) {
      setState(() {
        // Remove any existing user location measurements to avoid duplicates
        _measurementPoints
            .removeWhere((point) => point.id.startsWith('user_real_'));

        // Add new measurement point at user's current location
        _measurementPoints.add(MeasurementPoint(
          id: 'user_real_${DateTime.now().millisecondsSinceEpoch}',
          latitude: _userLatLng!.latitude,
          longitude: _userLatLng!.longitude,
          decibelLevel: decibelLevel,
          venueName: 'Your Location (Real)',
          venueType: 'Live Measurement',
        ));
      });
    }
  }

  /// Save map measurement to database for real-time updates
  Future<void> _saveMapMeasurement(MeasurementPoint point,
      double averageDecibel, NoiseMeasurementType measurementType) async {
    try {
      ref.read(locationProvider);

      // Create noise measurement from map location
      final measurement = NoiseMeasurement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        decibelLevel: averageDecibel,
        latitude: point.latitude,
        longitude: point.longitude,
        timestamp: DateTime.now(),
        type: _getMeasurementTypeEnum(measurementType),
        venueId: point.id,
        userId: 'current_user', // TODO: Get from auth
      );

      // Save to Hive database
      final noiseMeasurementsBox = ref.read(noiseMeasurementsBoxProvider);
      await noiseMeasurementsBox.add(measurement);

      debugPrint(
          '🗺️ Map measurement saved: ${averageDecibel.toStringAsFixed(1)} dB at ${point.venueName}');
    } catch (e) {
      debugPrint('Error saving map measurement: $e');
    }
  }

  /// Convert NoiseMeasurementType to MeasurementType enum
  MeasurementType _getMeasurementTypeEnum(NoiseMeasurementType type) {
    switch (type) {
      case NoiseMeasurementType.noiseMeasure:
        return MeasurementType.active;
      case NoiseMeasurementType.noiseLevel:
        return MeasurementType.active;
      case NoiseMeasurementType.venueMeasures:
        return MeasurementType.venue;
      case NoiseMeasurementType.complaints:
        return MeasurementType.active;
    }
  }

  /// Measure at user's current location
  void _measureAtCurrentLocation() {
    if (_userLatLng == null) return;

    // Create a temporary measurement point at user's location
    final userPoint = MeasurementPoint(
      id: 'user_location',
      latitude: _userLatLng!.latitude,
      longitude: _userLatLng!.longitude,
      decibelLevel: 0.0, // Will be updated after measurement
      venueName: 'Your Location',
      venueType: 'Current Location',
    );

    _startMeasurementAtLocation(userPoint);
  }

  void _loadRealMeasurements() async {
    // Load measurements from Hive and add them to the map
    try {
      final measurementsAsync = ref.read(noiseMeasurementsProvider);
      measurementsAsync.when(
        data: (measurements) {
          for (final measurement in measurements) {
            if (measurement.latitude != 0.0 && measurement.longitude != 0.0) {
              // Check if this measurement is near user's current location
              bool isUserLocation = false;
              if (_userLatLng != null) {
                final distance = _calculateDistance(
                  _userLatLng!.latitude,
                  _userLatLng!.longitude,
                  measurement.latitude,
                  measurement.longitude,
                );
                // If within 100 meters, consider it user's location
                isUserLocation = distance < 0.1; // 100 meters
              }

              _measurementPoints.add(MeasurementPoint(
                id: 'real_${measurement.id}',
                latitude: measurement.latitude,
                longitude: measurement.longitude,
                decibelLevel: measurement.decibelLevel,
                venueName: isUserLocation
                    ? 'Your Location (Real)'
                    : 'Real Measurement',
                venueType:
                    isUserLocation ? 'Live Measurement' : 'User Measured',
              ));
            }
          }
          if (mounted) setState(() {});
        },
        loading: () => debugPrint('Loading measurements...'),
        error: (error, stack) =>
            debugPrint('Error loading measurements: $error'),
      );
    } catch (e) {
      debugPrint('Error loading real measurements: $e');
    }
  }

  /// Calculate distance between two coordinates in kilometers
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

class MeasurementPoint {
  final String id;
  final double latitude;
  final double longitude;
  final double decibelLevel;
  final String venueName;
  final String venueType;

  MeasurementPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.decibelLevel,
    required this.venueName,
    required this.venueType,
  });
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw simple street grid
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (int i = 0; i < 15; i++) {
      final y = (size.height / 15) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw some building shapes
    final buildingPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final buildings = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, 80, 120),
      Rect.fromLTWH(size.width * 0.3, size.height * 0.15, 100, 150),
      Rect.fromLTWH(size.width * 0.6, size.height * 0.3, 90, 100),
      Rect.fromLTWH(size.width * 0.8, size.height * 0.1, 70, 180),
    ];

    for (final building in buildings) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(building, const Radius.circular(4)),
        buildingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
