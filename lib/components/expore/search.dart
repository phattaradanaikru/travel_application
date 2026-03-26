import 'package:flutter/material.dart';
import 'package:travel_application/data/services/apiservices.dart';
import 'package:travel_application/data/model/tatmodel.dart';
import 'dart:async';

import 'package:travel_application/page/detailpage.dart';

class Searchbar extends StatefulWidget {
  final Function(String)? onSearch;
  final Function()? onTap;
  final Function(Data)? onPlaceSelected;
  final TextEditingController? controller;
  final String hintText;
  final bool enabled;

  const Searchbar({
    super.key,
    this.onSearch,
    this.onTap,
    this.onPlaceSelected,
    this.controller,
    this.hintText = "ค้นหาสถานที่ท่องเที่ยว",
    this.enabled = true,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  late TextEditingController _controller;
  final ApiServices _apiServices = ApiServices();

  List<Data> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _searchTimer?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    _searchTimer?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showResults = true;
    });

    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        print('🔍 Searching API for: "$query"');

        final responseData = await _apiServices.searchPlaces(query);

        print('📊 API Response Keys: ${responseData.keys}');
        print('📊 Response Type: ${responseData.runtimeType}');

        if (responseData['data'] != null) {
          print('📊 Data Type: ${responseData['data'].runtimeType}');
          print('📊 Data Length: ${responseData['data'].length}');
        }

        final tatData = TaTData.fromJson(responseData);

        if (mounted) {
          setState(() {
            _searchResults = tatData.data ?? [];
            _isSearching = false;
          });

          print('✅ Search completed: ${_searchResults.length} results found');

          // แก้ไข Debug section
          if (_searchResults.isNotEmpty) {
            final firstResult = _searchResults.first;
            print('🏷️ First result: ${firstResult.name}');
            print('🏷️ Province: ${firstResult.location?.province?.name}');

            // Safe thumbnail debug
            if (firstResult.thumbnailUrl != null &&
                firstResult.thumbnailUrl!.isNotEmpty) {
              print('🏷️ Thumbnail: ${firstResult.thumbnailUrl!.first}');
            } else {
              print('🏷️ No thumbnail available');
            }
          }
        }
      } catch (e) {
        print('❌ Search error: $e');
        print('❌ Error type: ${e.runtimeType}');

        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  color: colorScheme.shadow.withOpacity(0.1),
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              onSubmitted: widget.onSearch,
              onTap: widget.onTap,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                prefixIcon:
                    _isSearching
                        ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                        : Icon(
                          Icons.search,
                          size: 24,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          onPressed: () {
                            _controller.clear();
                            widget.onSearch?.call('');
                            setState(() {
                              _searchResults = [];
                              _showResults = false;
                              _isSearching = false;
                            });
                            _searchTimer?.cancel();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onChanged: (value) {
                setState(() {});
                _performSearch(value);
              },
            ),
          ),
        ),

        if (_showResults) ...[
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  color: colorScheme.shadow.withOpacity(0.1),
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:
                _isSearching
                    ? Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'กำลังค้นหา...',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    )
                    : _searchResults.isEmpty
                    ? Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'ไม่พบสถานที่ท่องเที่ยว',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'ลองค้นหาด้วยคำอื่น',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            height: 1,
                            color: colorScheme.outline.withOpacity(0.2),
                          ),
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return _buildPlaceItem(place);
                      },
                    ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceItem(Data place) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
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
      borderRadius: BorderRadius.circular(12),
      splashColor: colorScheme.primary.withOpacity(0.1),
      highlightColor: colorScheme.primary.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    (place.thumbnailUrl != null &&
                            place.thumbnailUrl!.isNotEmpty &&
                            place.thumbnailUrl!.first.isNotEmpty)
                        ? Image.network(
                          place.thumbnailUrl!.first,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      colorScheme
                                          .primary, // ใช้ primary สำหรับ loading
                                  value:
                                      loadingProgress.expectedTotalBytes != null
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
                            print('❌ Image load error: $error');
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.landscape,
                                size: 30,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        )
                        : Icon(
                          Icons.landscape,
                          size: 30,
                          color: colorScheme.onSurfaceVariant,
                        ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name ?? 'ไม่มีชื่อ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (place.location?.province?.name != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: colorScheme.onSurface.withOpacity(
                            0.7,
                          ), // ใช้ onSurface สำหรับ location icon
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            place.location!.province!.name!,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(
                                0.7,
                              ), // ใช้ onSurface สำหรับ location text
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (place.category?.name != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            colorScheme
                                .primaryContainer, // ใช้ primaryContainer สำหรับ category background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        place.category!.name!,
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              colorScheme
                                  .onPrimaryContainer, // ใช้ onPrimaryContainer สำหรับ category text
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withOpacity(
                0.4,
              ), // ใช้ onSurface สำหรับ arrow icon
            ),
          ],
        ),
      ),
    );
  }
}
