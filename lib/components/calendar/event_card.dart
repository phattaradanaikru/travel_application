import 'package:flutter/material.dart';
import 'package:travel_application/data/model/traveleventmodel.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final TravelEvent event;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool isLarge;

  const EventCard({
    super.key,
    required this.event,
    this.onDelete,
    this.onEdit,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isLarge ? 100 : 80,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.type.color.withOpacity(0.3),
          width: isLarge ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(isLarge ? 0.1 : 0.05),
            blurRadius: isLarge ? 6 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isLarge ? 5 : 4,
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    event.type.color,
                    event.type.color.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isLarge ? 14 : 12), // ลด padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: event.type.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            event.type.icon,
                            color: event.type.color,
                            size: isLarge ? 18 : 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: isLarge ? 15 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  height: 1.2,
                                ),
                                maxLines: isLarge ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Type Badge - ย้ายมาใกล้ title
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: event.type.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  event.type.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: event.type.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (event.startTime != null || event.endTime != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTimeRange(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (event.location != null && event.location!.isNotEmpty)
                          Container(
                            constraints: const BoxConstraints(maxWidth: 120), // จำกัดความกว้าง
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    event.location!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    if (isLarge && 
                        event.description != null && 
                        event.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onEdit != null)
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit),
                              iconSize: 14,
                              color: colorScheme.primary,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        if (onEdit != null && onDelete != null)
                          const SizedBox(width: 6),
                        if (onDelete != null)
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete_outline),
                              iconSize: 14,
                              color: colorScheme.error,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeRange() {
    final timeFormat = DateFormat('HH:mm');
    
    if (event.startTime != null && event.endTime != null) {
      return '${timeFormat.format(event.startTime!)} - ${timeFormat.format(event.endTime!)}';
    } else if (event.startTime != null) {
      return '${timeFormat.format(event.startTime!)}';
    } else if (event.endTime != null) {
      return '${timeFormat.format(event.endTime!)}';
    }
    
    return 'ทั้งวัน';
  }
}