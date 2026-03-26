import 'package:flutter/material.dart';
import 'package:travel_application/data/services/apiservices.dart';
import 'package:travel_application/data/model/tatmodel.dart';
import 'package:travel_application/page/detailpage.dart';
import 'package:travel_application/components/expore/search.dart';
import 'package:travel_application/data/services/favoriteservice.dart';
import 'package:travel_application/data/services/calendarservice.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ApiServices _apiServices = ApiServices();
  final FavoriteService _favoriteService = FavoriteService();
  final CalendarService _calendarService = CalendarService();

  List<Data> _places = [];
  bool _isLoading = true;
  bool _hasError = false;

  Set<String> _favoriteIds = {};
  Set<String> _addedIds = {};

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _loadCalendarEvents();
  }

  Future<void> _loadPlaces() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('🔄 Loading places from API...');
      final responseData = await _apiServices.getPlaces();

      print('📊 API Response Keys: ${responseData.keys}');

      final tatData = TaTData.fromJson(responseData);

      setState(() {
        _places = tatData.data ?? [];
        _isLoading = false;
      });

      print('✅ Loaded ${_places.length} places');
    } catch (e) {
      print('❌ Error loading places: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadCalendarEvents() async {
    try {
      final events = await _calendarService.getEvents();
      final Set<String> eventPlaceIds = {};

      for (final eventList in events.values) {
        for (final event in eventList) {
          if (event.placeId != null) {
            eventPlaceIds.add(event.placeId!);
          }
        }
      }

      setState(() {
        _addedIds = eventPlaceIds;
      });

      print('✅ Loaded ${eventPlaceIds.length} places with calendar events');
    } catch (e) {
      print('❌ Error loading calendar events: $e');
    }
  }

  Future<void> _refreshPlaces() async {
    await _loadPlaces();
    await _loadCalendarEvents();
  }

  void _toggleFavorite(Data place) async {
    try {
      final placeId = place.placeId?.toString() ?? '';

      if (_favoriteIds.contains(placeId)) {
        await _favoriteService.removeFromFavorites(placeId);
        setState(() {
          _favoriteIds.remove(placeId);
        });
        _showSnackBar('ลบออกจากรายการโปรดแล้ว', Icons.heart_broken);
      } else {
        await _favoriteService.addToFavorites(place);
        setState(() {
          _favoriteIds.add(placeId);
        });
        _showSnackBar('เพิ่มในรายการโปรดแล้ว', Icons.favorite);
      }
    } catch (e) {
      _showSnackBar('เกิดข้อผิดพลาด: $e', Icons.error);
    }
  }

  void _toggleAdd(Data place) async {
    try {
      final placeId = place.placeId?.toString() ?? '';

      if (_addedIds.contains(placeId)) {
        await _removeEventsByPlaceId(placeId);
      } else {
        await _addToCalendar(place);
      }
    } catch (e) {
      _showSnackBar('เกิดข้อผิดพลาด: $e', Icons.error);
    }
  }

  Future<void> _addToCalendar(Data place) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('th', 'TH'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
      helpText: 'เลือกวันที่ท่องเที่ยว',
      cancelText: 'ยกเลิก',
      confirmText: 'เลือก',
    );

    if (selectedDate != null) {
      final result = await _showAddEventDetailsDialog(place, selectedDate);

      if (result != null) {
        try {
          await _calendarService.addEventFromPlace(
            placeId: place.placeId?.toString() ?? '',
            placeName: place.name ?? 'สถานที่ท่องเที่ยว',
            date: selectedDate,
            location: _buildLocationString(place),
            description: result['description'],
            startTime: result['startTime'],
            endTime: result['endTime'],
            notes: result['notes'],
          );

          setState(() {
            _addedIds.add(place.placeId?.toString() ?? '');
          });

          _showSnackBar(
            'เพิ่มลงปฏิทินวันที่ ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} แล้ว',
            Icons.calendar_today,
          );
        } catch (e) {
          _showSnackBar('เกิดข้อผิดพลาดในการเพิ่มลงปฏิทิน: $e', Icons.error);
        }
      }
    }
  }

  Future<Map<String, dynamic>?> _showAddEventDetailsDialog(
    Data place,
    DateTime selectedDate,
  ) async {
    final descriptionController = TextEditingController();
    final notesController = TextEditingController();

    descriptionController.text = 'เที่ยวชม${place.name ?? ''}';

    TimeOfDay? startTime;
    TimeOfDay? endTime;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เพิ่มลงปฏิทิน',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.name ?? 'สถานที่ท่องเที่ยว',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'วันที่: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.access_time),
                                title: const Text('เวลาเริ่ม'),
                                subtitle: Text(
                                  startTime?.format(context) ?? 'ไม่ระบุ',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        startTime ??
                                        const TimeOfDay(hour: 9, minute: 0),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      );
                                    },
                                    helpText: 'เลือกเวลาเริ่ม',
                                    cancelText: 'ยกเลิก',
                                    confirmText: 'เลือก',
                                  );
                                  if (time != null) {
                                    setDialogState(() {
                                      startTime = time;
                                    });
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.access_time_filled),
                                title: const Text('เวลาจบ'),
                                subtitle: Text(
                                  endTime?.format(context) ?? 'ไม่ระบุ',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        endTime ??
                                        const TimeOfDay(hour: 17, minute: 0),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      );
                                    },
                                    helpText: 'เลือกเวลาจบ',
                                    cancelText: 'ยกเลิก',
                                    confirmText: 'เลือก',
                                  );
                                  if (time != null) {
                                    setDialogState(() {
                                      endTime = time;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'รายละเอียดกิจกรรม',
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),

                        const SizedBox(height: 16),

                        // หมายเหตุ
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'หมายเหตุ',
                            prefixIcon: Icon(Icons.note),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('ยกเลิก'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'startTime': startTime,
                          'endTime': endTime,
                          'description': descriptionController.text.trim(),
                          'notes': notesController.text.trim(),
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('เพิ่มลงปฏิทิน'),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _removeEventsByPlaceId(String placeId) async {
    try {
      final events = await _calendarService.getEvents();

      for (final eventList in events.values) {
        for (final event in eventList) {
          if (event.placeId == placeId) {
            await _calendarService.removeEvent(event.id);
          }
        }
      }

      setState(() {
        _addedIds.remove(placeId);
      });

      _showSnackBar('ลบออกจากปฏิทินแล้ว', Icons.calendar_today);
    } catch (e) {
      _showSnackBar('เกิดข้อผิดพลาดในการลบจากปฏิทิน: $e', Icons.error);
    }
  }

  String _buildLocationString(Data place) {
    final parts = <String>[];

    if (place.location?.district?.name != null) {
      parts.add(place.location!.district!.name!);
    }

    if (place.location?.province?.name != null) {
      parts.add(place.location!.province!.name!);
    }

    return parts.join(', ');
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Searchbar(
              onPlaceSelected: (place) {
                print('🎯 Selected place: ${place.name}');
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
                      ? _buildLoadingState()
                      : _hasError
                      ? _buildErrorState()
                      : _places.isEmpty
                      ? _buildEmptyState()
                      : _buildPlacesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'กำลังโหลดสถานที่ท่องเที่ยว...',
            style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'เกิดข้อผิดพลาด',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ไม่สามารถโหลดข้อมูลได้\nกรุณาตรวจสอบการเชื่อมต่อและลองใหม่',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshPlaces,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_off,
              size: 64,
              color: colorScheme.onBackground.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่พบสถานที่ท่องเที่ยว',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ขณะนี้ยังไม่มีข้อมูลสถานที่ท่องเที่ยว',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList() {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _refreshPlaces,
      color: colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'สถานที่ท่องเที่ยว',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final place = _places[index];
                return _buildPlaceCard(place);
              }, childCount: _places.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Data place) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final placeId = place.placeId?.toString() ?? '';
    final isFavorite = _favoriteIds.contains(placeId);
    final isInCalendar = _addedIds.contains(placeId);

    return Card(
      elevation: 4,
      shadowColor: colorScheme.shadow.withOpacity(0.3),
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          print('🎯 Tapped place: ${place.name}');

          final placeId = place.placeId?.toString();
          if (placeId != null && placeId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        DetailPage(placeId: placeId, placeName: place.name),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ไม่สามารถเปิดรายละเอียดได้: ไม่มีรหัสสถานที่'),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child:
                          (place.thumbnailUrl != null &&
                                  place.thumbnailUrl!.isNotEmpty &&
                                  place.thumbnailUrl!.first.isNotEmpty)
                              ? Image.network(
                                place.thumbnailUrl!.first,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: colorScheme.surfaceVariant,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.primary,
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: colorScheme.surfaceVariant,
                                    child: Center(
                                      child: Icon(
                                        Icons.landscape,
                                        size: 40,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              )
                              : Container(
                                color: colorScheme.surfaceVariant,
                                child: Center(
                                  child: Icon(
                                    Icons.landscape,
                                    size: 40,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _toggleFavorite(place),
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color:
                                      isFavorite
                                          ? Colors.red
                                          : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _toggleAdd(place),
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Icon(
                                  isInCalendar
                                      ? Icons.calendar_today
                                      : Icons.calendar_today_outlined,
                                  size: 18,
                                  color:
                                      isInCalendar
                                          ? Colors.blue
                                          : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              height: 120,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      place.name ?? 'ไม่มีชื่อ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (place.location?.province?.name != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 11,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            place.location!.province!.name!,
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.7),
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (place.category?.name != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              place.category!.name!,
                              style: TextStyle(
                                fontSize: 8,
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Status Indicators
                      Row(
                        children: [
                          if (isFavorite) ...[
                            Icon(Icons.favorite, size: 12, color: Colors.red),
                            const SizedBox(width: 4),
                          ],
                          if (isInCalendar)
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
