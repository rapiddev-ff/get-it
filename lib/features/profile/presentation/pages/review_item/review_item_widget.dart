import '/features/home/domain/models/review_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({
    super.key,
    required this.reviewDataType,
  });

  final Review? reviewDataType;

  @override
  Widget build(BuildContext context) {
    if (reviewDataType == null) return const SizedBox.shrink();
    final review = reviewDataType!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.neutral800,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: (review.reviewer?.avatarUrl ?? '').isNotEmpty
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 500),
                          imageUrl: review.reviewer?.avatarUrl ?? '',
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: 20.0,
                          color: AppColors.textSecondary,
                        ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          review.reviewer?.username,
                          'N/A',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        dateTimeFormat(
                          "yMMMd",
                          review.createdAt ?? DateTime.now(),
                        ),
                        style: Theme.of(context).textTheme.labelSmall!,
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: AppColors.statusYellow,
                  ),
                  direction: Axis.horizontal,
                  rating: review.rating.toDouble(),
                  unratedColor: AppColors.neutral700,
                  itemCount: 5,
                  itemSize: 18.0,
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            Text(
              valueOrDefault<String>(
                review.content,
                'N/A',
              ),
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
