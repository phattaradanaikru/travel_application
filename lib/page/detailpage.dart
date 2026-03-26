import 'package:flutter/material.dart';
import 'package:travel_application/data/services/apiservices.dart';
import 'package:travel_application/data/model/detailsmodel.dart';
import 'package:travel_application/components/detail/detail_image_gallery.dart';
import 'package:travel_application/components/detail/detail_place_info.dart';
import 'package:travel_application/components/detail/detail_states.dart';
import 'package:travel_application/data/services/favoriteservice.dart';
import 'package:travel_application/data/services/calendarservice.dart';

class DetailPage extends StatefulWidget {
  final String placeId;
  final String? placeName;

  const DetailPage({super.key, required this.placeId, this.placeName});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiServices _apiServices = ApiServices();
  final FavoriteService _favoriteService = FavoriteService();
  final CalendarService _calendarService = CalendarService();

  detail_place? _placeDetail;
  bool _isLoading = true;
  bool _hasError = false;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  bool _isFavorite = false;
  bool _isInCalendar = false;
  bool _isButtonLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child:
            _isLoading
                ? DetailStates.buildLoadingState(context)
                : _hasError
                ? DetailStates.buildErrorState(
                  context,
                  onRetry: _loadPlaceDetail,
                  onBack: () => Navigator.pop(context),
                )
                : _placeDetail == null
                ? DetailStates.buildNotFoundState(
                  context,
                  placeId: widget.placeId,
                  onRetry: _loadPlaceDetail,
                  onBack: () => Navigator.pop(context),
                )
                : _buildDetailContent(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPlaceDetail();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaceDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      print('🔍 Loading detail for ID: ${widget.placeId}');

      final responseData = await _apiServices.getPlaceDetail(widget.placeId);

      detail_place? placeData;

      try {
        if (responseData['placeId'] != null) {
          placeData = detail_place.fromJson(responseData);
          print('✅ Found direct data');
        } else if (responseData['result'] != null) {
          placeData = detail_place.fromJson(responseData['result']);
          print('✅ Found data in "result" key');
        } else if (responseData['data'] != null) {
          if (responseData['data'] is List &&
              (responseData['data'] as List).isNotEmpty) {
            placeData = detail_place.fromJson(
              (responseData['data'] as List).first,
            );
            print('✅ Found data in "data" array');
          } else if (responseData['data'] is Map) {
            placeData = detail_place.fromJson(responseData['data']);
            print('✅ Found data in "data" object');
          }
        } else if (responseData['place'] != null) {
          placeData = detail_place.fromJson(responseData['place']);
          print('✅ Found data in "place" key');
        } else {
          print('🔍 Trying to parse entire response as place data');
          placeData = detail_place.fromJson(responseData);
          print('✅ Parsed entire response');
        }
      } catch (parseError) {
        print('❌ Error parsing specific structure: $parseError');
        try {
          placeData = detail_place.fromJson(responseData);
          print('✅ Fallback parsing successful');
        } catch (fallbackError) {
          print('❌ Fallback parsing failed: $fallbackError');
          throw Exception('Cannot parse response data');
        }
      }

      setState(() {
        _placeDetail = placeData;
        _isLoading = false;
      });

      print('✅ Place detail loaded: ${_placeDetail?.name}');

      await _loadFavoriteStatus();
    } catch (e) {
      print('❌ Error loading place detail: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final isFavorite = await _favoriteService.isInFavorites(widget.placeId);

      final isInCalendar = await _checkIfInCalendar(widget.placeId);

      setState(() {
        _isFavorite = isFavorite;
        _isInCalendar = isInCalendar;
      });

      print(
        '✅ Firebase status loaded: favorite=$isFavorite, inCalendar=$isInCalendar',
      );
    } catch (e) {
      print('❌ Error loading Firebase status: $e');
    }
  }

  Future<bool> _checkIfInCalendar(String placeId) async {
    try {
      final events = await _calendarService.getEvents();

      for (final eventList in events.values) {
        for (final event in eventList) {
          if (event.placeId == placeId) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('❌ Error checking calendar: $e');
      return false;
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isButtonLoading || _placeDetail == null) return;

    try {
      setState(() {
        _isButtonLoading = true;
      });

      if (_isFavorite) {
        await _favoriteService.removeFromFavorites(widget.placeId);
        setState(() {
          _isFavorite = false;
        });
        _showSnackBar('ลบออกจากรายการโปรดแล้ว', Icons.heart_broken);
      } else {
        final placeMap = _createPlaceMap(_placeDetail!);
        await _favoriteService.addToFavoritesMap(widget.placeId, placeMap);
        setState(() {
          _isFavorite = true;
        });
        _showSnackBar('เพิ่มในรายการโปรดแล้ว', Icons.favorite);
      }
    } catch (e) {
      print('❌ Error toggling favorite: $e');
      _showSnackBar('เกิดข้อผิดพลาด: $e', Icons.error);
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _toggleCalendar() async {
    if (_isButtonLoading || _placeDetail == null) return;

    try {
      setState(() {
        _isButtonLoading = true;
      });

      if (_isInCalendar) {
        await _removeEventsFromCalendar(widget.placeId);
        setState(() {
          _isInCalendar = false;
        });
        _showSnackBar('ลบออกจากปฏิทินแล้ว', Icons.calendar_today);
      } else {
        await _addToCalendar(_placeDetail!);
      }
    } catch (e) {
      print('❌ Error toggling calendar: $e');
      _showSnackBar('เกิดข้อผิดพลาด: $e', Icons.error);
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _addToCalendar(detail_place place) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('en', 'US'),
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
            placeId: widget.placeId,
            placeName: place.name ?? 'สถานที่ท่องเที่ยว',
            date: selectedDate,
            location: _buildLocationString(place),
            description: result['description'],
            startTime: result['startTime'],
            endTime: result['endTime'],
            notes: result['notes'],
          );

          setState(() {
            _isInCalendar = true;
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
    detail_place place,
    DateTime selectedDate,
  ) async {
    final descriptionController = TextEditingController();
    final notesController = TextEditingController();

    descriptionController.text = 'เที่ยวชม ${place.name ?? ''}';

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

  Future<void> _removeEventsFromCalendar(String placeId) async {
    try {
      final events = await _calendarService.getEvents();

      for (final eventList in events.values) {
        for (final event in eventList) {
          if (event.placeId == placeId) {
            await _calendarService.removeEvent(event.id);
          }
        }
      }

      print('✅ Removed all events for place: $placeId');
    } catch (e) {
      print('❌ Error removing events from calendar: $e');
      rethrow;
    }
  }

  String _buildLocationString(detail_place place) {
    final parts = <String>[];

    if (place.location?.district?.name != null) {
      parts.add(place.location!.district!.name!);
    }

    if (place.location?.province?.name != null) {
      parts.add(place.location!.province!.name!);
    }

    return parts.join(', ');
  }

  Map<String, dynamic> _createPlaceMap(detail_place place) {
    return {
      'placeId': place.placeId,
      'name': place.name,
      'location': {
        'province': {
          'provinceId': place.location?.province?.provinceId,
          'name': place.location?.province?.name,
        },
        'district': {
          'districtId': place.location?.district?.districtId,
          'name': place.location?.district?.name,
        },
        'address': place.location?.address,
      },
      'category': {
        'categoryId': place.category?.categoryId,
        'name': place.category?.name,
      },
      'thumbnailUrl':
          place.thumbnailUrl != null && place.thumbnailUrl!.isNotEmpty
              ? [place.thumbnailUrl!]
              : place.desktopImageUrls ?? place.mobileImageUrls ?? [],
      'addedAt': DateTime.now().toIso8601String(),
    };
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

  void _onImagePageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  Widget _buildDetailContent() {
    final place = _placeDetail!;

    return CustomScrollView(
      slivers: [
        DetailImageGallery(
          place: place,
          pageController: _pageController,
          currentImageIndex: _currentImageIndex,
          onPageChanged: _onImagePageChanged,
        ),

        SliverToBoxAdapter(
          child: DetailPlaceInfo(
            place: place,
            placeName: widget.placeName,
            placeId: widget.placeId,
            onFavoritePressed: _isButtonLoading ? null : _toggleFavorite,
            onAddPressed:
                _isButtonLoading ? null : _toggleCalendar, // เปลี่ยน method
            isFavorite: _isFavorite,
            isAdded: _isInCalendar, // เปลี่ยนตัวแปร
          ),
        ),
      ],
    );
  }
}
