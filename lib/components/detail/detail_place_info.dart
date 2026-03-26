import 'package:flutter/material.dart';
import 'package:travel_application/data/model/detailsmodel.dart';
import 'package:travel_application/components/detail/detail_sections.dart';

class DetailPlaceInfo extends StatelessWidget {
  final detail_place place;
  final String? placeName;
  final String placeId;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onAddPressed;
  final bool isFavorite;
  final bool isAdded;

  const DetailPlaceInfo({
    super.key,
    required this.place,
    this.placeName,
    required this.placeId,
    this.onFavoritePressed,
    this.onAddPressed,
    this.isFavorite = false,
    this.isAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailSections.buildHeader(
              context,
              place,
              placeName,
              onFavoritePressed: onFavoritePressed,
              onAddPressed: onAddPressed,
              isFavorite: isFavorite,
              isAdded: isAdded,
            ),
            const SizedBox(height: 24),

            DetailSections.buildLocationSection(context, place),
            const SizedBox(height: 24),

            DetailSections.buildCategorySection(context, place),
            const SizedBox(height: 24),

            DetailSections.buildDescriptionSection(context, place),
            const SizedBox(height: 24),

            DetailSections.buildTagsSection(context, place),
            const SizedBox(height: 24),

            DetailSections.buildFacilitiesSection(context, place),
            const SizedBox(height: 24),

            if (place.contact != null)
              DetailSections.buildContactSection(context, place.contact!),
            const SizedBox(height: 24),

            DetailSections.buildAdditionalInfo(context, place, placeId),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
