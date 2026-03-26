import 'package:flutter/material.dart';
import 'package:travel_application/data/model/detailsmodel.dart';

class DetailSections {
  static Widget buildHeader(
    BuildContext context,
    detail_place place,
    String? placeName, {
    VoidCallback? onFavoritePressed,
    VoidCallback? onAddPressed,
    bool isFavorite = false,
    bool isAdded = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          place.name ?? placeName ?? 'ไม่มีชื่อ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
            height: 1.2,
          ),
          minLines: 1,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onFavoritePressed,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                ),
                label: Text(
                  isFavorite ? 'ลบจากโปรด' : 'เพิ่มรายการโปรด',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFavorite
                          ? Colors.red.withOpacity(0.1)
                          : colorScheme.primaryContainer,
                  foregroundColor:
                      isFavorite ? Colors.red : colorScheme.onPrimaryContainer,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          isFavorite
                              ? Colors.red.withOpacity(0.3)
                              : colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAddPressed,
                icon: Icon(
                  isAdded ? Icons.check_circle : Icons.add_circle_outline,
                  size: 20,
                ),
                label: Text(
                  isAdded ? 'ลบจากรายการ' : 'เพิ่มรายการท่องเที่ยว',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isAdded
                          ? Colors.green.withOpacity(0.1)
                          : colorScheme.secondaryContainer,
                  foregroundColor:
                      isAdded ? Colors.green : colorScheme.onSecondaryContainer,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          isAdded
                              ? Colors.green.withOpacity(0.3)
                              : colorScheme.secondary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (isFavorite || isAdded) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              if (isFavorite) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        'ในรายการโปรด',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isAdded) const SizedBox(width: 8),
              ],
              if (isAdded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'ในรายการท่องเที่ยว',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  static Widget buildLocationSection(BuildContext context, detail_place place) {
    final colorScheme = Theme.of(context).colorScheme;

    if (place.location?.province?.name == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ที่ตั้ง',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            '${place.location?.district?.name ?? ''} ${place.location?.province?.name ?? ''}'
                .trim(),
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          if (place.location?.address != null &&
              place.location!.address!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText(
              place.location!.address!,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildCategorySection(BuildContext context, detail_place place) {
    final colorScheme = Theme.of(context).colorScheme;

    if (place.category?.name == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.category, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'หมวดหมู่:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              place.category!.name!,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildDescriptionSection(
    BuildContext context,
    detail_place place,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    String? introduction = place.information?.introduction;
    String? detail = place.information?.detail;

    introduction = _cleanHtmlTags(introduction);
    detail = _cleanHtmlTags(detail);

    if ((introduction == null || introduction.isEmpty) &&
        (detail == null || detail.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'รายละเอียด',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Introduction Section
          if (introduction != null && introduction.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'คำแนะนำ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              introduction,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ],

          if (detail != null && detail.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'รายละเอียดเพิ่มเติม',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              detail,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildTagsSection(BuildContext context, detail_place place) {
    final colorScheme = Theme.of(context).colorScheme;

    if (place.tags == null || place.tags!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tag, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'แท็ก',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  place.tags!.map((tag) {
                    return Container(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.secondary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  // Facilities Section
  static Widget buildFacilitiesSection(
    BuildContext context,
    detail_place place,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (place.facilities == null || place.facilities!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.business, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'สิ่งอำนวยความสะดวก',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: Column(
            children:
                place.facilities!.map((facility) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            facility.name ?? 'ไม่ระบุ',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // Contact Section
  static Widget buildContactSection(BuildContext context, Contact contact) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ข้อมูลติดต่อ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contact.phones != null && contact.phones!.isNotEmpty) ...[
                _buildContactRow(
                  context,
                  Icons.phone,
                  'โทรศัพท์',
                  contact.phones!.join(', '),
                ),
                const SizedBox(height: 8),
              ],
              if (contact.mobiles != null && contact.mobiles!.isNotEmpty) ...[
                _buildContactRow(
                  context,
                  Icons.smartphone,
                  'มือถือ',
                  contact.mobiles!.join(', '),
                ),
                const SizedBox(height: 8),
              ],
              if (contact.emails != null && contact.emails!.isNotEmpty) ...[
                _buildContactRow(
                  context,
                  Icons.email,
                  'อีเมล',
                  contact.emails!.join(', '),
                ),
                const SizedBox(height: 8),
              ],
              if (contact.urls != null && contact.urls!.isNotEmpty)
                _buildContactRow(
                  context,
                  Icons.language,
                  'เว็บไซต์',
                  contact.urls!.join(', '),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  // Additional Info Section
  static Widget buildAdditionalInfo(
    BuildContext context,
    detail_place place,
    String placeId,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    List<Widget> infoWidgets = [];

    // Distance
    if (place.distance != null) {
      infoWidgets.add(
        _buildInfoItem(
          context,
          icon: Icons.straighten,
          label: 'ระยะทาง',
          value: '${place.distance} กม.',
        ),
      );
    }

    // Price Range
    if (place.minPrice != null || place.maxPrice != null) {
      String priceText = '';
      if (place.minPrice != null && place.maxPrice != null) {
        priceText = '${place.minPrice} - ${place.maxPrice} บาท';
      } else if (place.minPrice != null) {
        priceText = 'เริ่มต้น ${place.minPrice} บาท';
      } else if (place.maxPrice != null) {
        priceText = 'สูงสุด ${place.maxPrice} บาท';
      }

      if (priceText.isNotEmpty) {
        infoWidgets.add(
          _buildInfoItem(
            context,
            icon: Icons.attach_money,
            label: 'ราคา',
            value: priceText,
          ),
        );
      }
    }

    // Place ID
    infoWidgets.add(
      _buildInfoItem(
        context,
        icon: Icons.fingerprint,
        label: 'รหัสสถานที่',
        value: place.placeId?.toString() ?? placeId,
      ),
    );

    // Update Date
    if (place.updatedAt != null) {
      infoWidgets.add(
        _buildInfoItem(
          context,
          icon: Icons.update,
          label: 'อัพเดทล่าสุด',
          value: _formatDate(place.updatedAt!),
        ),
      );
    }

    if (infoWidgets.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลเพิ่มเติม',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...infoWidgets
              .map(
                (widget) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: widget,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  static Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
    } catch (e) {
      return dateString;
    }
  }

  // Helper method สำหรับทำความสะอาด HTML tags
  static String? _cleanHtmlTags(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return null;

    // ลบ HTML tags และ entities
    String cleanText =
        htmlString
            // ลบ HTML tags ทั้งหมด
            .replaceAll(RegExp(r'<[^>]*>'), '')
            // แทนที่ HTML entities
            .replaceAll('&nbsp;', ' ')
            .replaceAll('&amp;', '&')
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&quot;', '"')
            .replaceAll('&#39;', "'")
            .replaceAll('&#x27;', "'")
            .replaceAll('&apos;', "'")
            // ลบ whitespace หลายตัว
            .replaceAll(RegExp(r'\s+'), ' ')
            // ตัด space หน้าหลัง
            .trim();

    return cleanText.isEmpty ? null : cleanText;
  }
}
