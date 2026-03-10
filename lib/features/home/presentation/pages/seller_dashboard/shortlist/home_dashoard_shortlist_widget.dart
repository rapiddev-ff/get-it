import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_item/shortlist_item_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_create/home_dashoard_shortlist_create_widget.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';


class HomeDashoardShortlistWidget extends ConsumerStatefulWidget {
  const HomeDashoardShortlistWidget({super.key});

  static String routeName = 'homeDashoardShortlist';
  static String routePath = 'homeDashoardShortlist';

  @override
  ConsumerState<HomeDashoardShortlistWidget> createState() =>
      _HomeDashoardShortlistWidgetState();
}

class _HomeDashoardShortlistWidgetState
    extends ConsumerState<HomeDashoardShortlistWidget> {
  List<ShortlistsRow> shortlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShortlists();
  }

  Future<void> _loadShortlists() async {
    final rows = await ShortlistsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('seller_id', ref.read(currentUserIdProvider))
          .neq('status', 'archived')
          .order('created_at'),
    );
    if (!mounted) return;
    setState(() {
      shortlists = rows;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Text(
                  'Event Shortlists',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                )
              : shortlists.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.qrcode,
                                    color: AppColors.textSecondary,
                                    size: 64.0,
                                  ),
                                  SizedBox(height: 24.0),
                                  Text(
                                    'No shortlists yet',
                                    style:
                                        Theme.of(context).textTheme.titleLarge!,
                                  ),
                                  SizedBox(height: 8.0),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Text(
                                      'Create a shortlist for an event to share products with a QR code and track scans.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!,
                                    ),
                                  ),
                                  SizedBox(height: 24.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.brandPurple,
                                          AppColors.brandBlue
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        await context.pushNamed(
                                            HomeDashoardShortlistCreateWidget
                                                .routeName);
                                        _loadShortlists();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          'Create New Shortlist',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
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
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          ListView.separated(
                            padding: EdgeInsets.fromLTRB(0, 24.0, 0, 24.0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shortlists.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.0),
                            itemBuilder: (context, index) {
                              return ShortlistItemWidget(
                                  shortlist: shortlists[index],
                                  onChanged: _loadShortlists);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
                              width: double.infinity,
                              height: 56.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.brandPurple,
                                    AppColors.brandBlue
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await context.pushNamed(
                                      HomeDashoardShortlistCreateWidget
                                          .routeName);
                                  _loadShortlists();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 24.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Create New Shortlist',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'How QR Codes Work',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        height: 1.5,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.print,
                                          color: AppColors.secondary,
                                          size: 24.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Print QR codes for your booth',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.share,
                                          color: AppColors.secondary,
                                          size: 24.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Share digitally on social media',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.bar_chart,
                                          color: AppColors.secondary,
                                          size: 24.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Track scans and purchases',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.0),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
