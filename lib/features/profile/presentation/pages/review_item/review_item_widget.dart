import '/features/home/domain/models/review_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({
    super.key,
    required this.reviewDataType,
  });

  final Review? reviewDataType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color(0xFF545454),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: (reviewDataType!.reviewer?.avatarUrl ?? '').isNotEmpty
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 500),
                          imageUrl: reviewDataType!.reviewer!.avatarUrl,
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
                          reviewDataType?.reviewer?.username,
                          'N/A',
                        ),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        dateTimeFormat(
                          "yMMMd",
                          reviewDataType!.createdAt!,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: Color(0xFFAFAFB4),
                        ),
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFACC15),
                  ),
                  direction: Axis.horizontal,
                  rating: (reviewDataType?.rating ?? 0).toDouble(),
                  unratedColor: Color(0xFF7B7B7B),
                  itemCount: 5,
                  itemSize: 18.0,
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            Text(
              valueOrDefault<String>(
                reviewDataType?.content,
                'N/A',
              ),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                color: AppColors.textPrimary,
              ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}
