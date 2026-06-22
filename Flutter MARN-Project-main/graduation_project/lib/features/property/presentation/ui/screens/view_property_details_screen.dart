import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/utilities/app_images.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/core/widgets/my_show_dialog.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/amenity_box.dart';
import 'package:MARN/features/property/presentation/ui/widgets/booking_bottom_sheet.dart';
import 'package:MARN/features/property/presentation/ui/widgets/love_button.dart';
import 'package:MARN/features/property/presentation/ui/widgets/show_map.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:MARN/core/widgets/show_report_dialog.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';
import 'package:MARN/features/property/presentation/ui/widgets/share_property.dart';

class ViewPropertyDetailsScreen extends StatefulWidget {
  final PropertyViewEntity property;

  const ViewPropertyDetailsScreen({super.key, required this.property});

  @override
  State<ViewPropertyDetailsScreen> createState() =>
      _ViewPropertyDetailsScreenState();
}

class _ViewPropertyDetailsScreenState extends State<ViewPropertyDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _editCommentController = TextEditingController();
  int _selectedRating = 0;
  int _editingRating = 0;
  bool _isSubmitting = false;
  PropertyCommentDetailsEntity? _editingComment;

  final _addFeedbackFormKey = GlobalKey<FormState>();
  final _editFeedbackFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    _editCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyFeedbackSuccess) {
          setState(() {
            _commentController.clear();
            _selectedRating = 0;
            _editingRating = 0;
            _editingComment = null;
            _editCommentController.clear();
            _isSubmitting = false;
          });
          context.read<PropertyCubit>().getPropertyDetails(
            propertyId: widget.property.id,
          );
        } else if (state is PropertyFeedbackFailure) {
          setState(() {
            _isSubmitting = false;
          });
          buildSnackBar(context, message: state.errorMessage, isError: true);
        } else if (state is PropertyFeedbackLoading) {
          setState(() {
            _isSubmitting = true;
          });
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          context.pop(widget.property.isSaved);
        },
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await context.read<PropertyCubit>().getPropertyDetails(
                  propertyId: widget.property.id,
                );
              },
              child: CustomScrollView(
                physics: const TopBounceOnlyScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                ),
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 24,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHeaderInfo(),
                          _buildAboutSection(),
                          if (widget.property.amenities.isNotEmpty) ...[
                            _buildAmenitiesSection(),
                          ],
                          if (widget.property.rules.isNotEmpty) ...[
                            _buildRulesSection(),
                          ],
                          if (widget.property.activeRenters.isNotEmpty) ...[
                            _buildActiveRentersSection(),
                          ],
                          if (!widget.property.isPersonal) ...[
                            _buildHostSection(),
                            CustomGeneralButton(
                              onPressed: _showBookingBottomSheet,
                              text: LocaleKeys.propertyButtonsBookNow.tr(),
                            ),
                          ],
                          if (widget
                              .property
                              .currentUserBookingRequests
                              .isNotEmpty) ...[
                            _buildCurrentUserBookingRequests(),
                          ],
                          if (widget.property.ownerExtras != null &&
                              widget.property.isPersonal) ...[
                            _buildOwnerExtrasSection(),
                          ],
                          _buildReviewsSection(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final mediaPaths = widget.property.media.map((e) => e.path).toList();

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primarySecond,
      surfaceTintColor: AppColors.primary,
      actions: [
        if (!widget.property.isPersonal)
          IconButton(
            icon: const Icon(Icons.report_outlined, color: AppColors.error),
            onPressed: () {
              showReportDialog(
                context,
                reportableType:
                    EnumHelper.getEnum(
                      context,
                      EnumType.reportableTypes,
                    )?.firstWhere(
                      (e) => e.name.toLowerCase() == 'property',
                      orElse: () => EnumItem(
                        id: 0,
                        name: 'property',
                        displayName: 'Property',
                      ),
                    ) ??
                    EnumItem(id: 0, name: 'property', displayName: 'Property'),
                reportableTargetId: widget.property.id.toString(),
              );
            },
          ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
          onPressed: () => shareProperty(context, widget.property),
        ),
        LoveButton(
          isLiked: widget.property.isSaved,
          onPressed: () {
            context.read<PropertyCubit>().toggleSaveProperty(
              propertyId: widget.property.id,
            );
            setState(() {
              widget.property.isSaved = !widget.property.isSaved;
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: mediaPaths.isNotEmpty ? mediaPaths.length : 1,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (mediaPaths.isEmpty) {
                  return Image.asset(Assets.imagesNoImage);
                }
                final path = mediaPaths[index];
                return Image.network(path, fit: BoxFit.cover);
              },
            ),
            if (mediaPaths.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    mediaPaths.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImageIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.54),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            if (mediaPaths.length > 1)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white.withOpacity(0.8),
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (mediaPaths.length > 1)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white.withOpacity(0.8),
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.property.title, style: AppTextStyles.titleLarge),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primarySoft),
              ),
              child: Text(
                widget.property.type.displayName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primarySoft),
              ),
              child: Text(
                widget.property.isActive
                    ? LocaleKeys.propertyStatusActive.tr()
                    : LocaleKeys.propertyStatusInactive.tr(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: widget.property.isActive
                      ? AppColors.success
                      : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primarySoft),
              ),
              child: Text(
                widget.property.availability
                    ? LocaleKeys.propertyStatusAvailable.tr()
                    : LocaleKeys.propertyStatusNotAvailable.tr(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: widget.property.availability
                      ? AppColors.success
                      : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.successSoft),
              ),
              child: Text(
                "${widget.property.price} ${widget.property.rentalUnit.displayName}",
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomGeneralContainer(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primarySoft,
                    ),
                    icon: const Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      _showMapDialog(
                        context,
                        widget.property.latitude,
                        widget.property.longitude,
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${widget.property.address}, ${widget.property.city.displayName}, ${widget.property.governorate.displayName} ${widget.property.zipCode}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.available,
                    ),
                    Text(
                      widget.property.averageRating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LocaleKeys.propertyDetailsReviewsCount.tr(
                        namedArgs: {
                          'count': widget.property.ratingsCount.toString(),
                        },
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "|",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.visibility,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    Text(
                      LocaleKeys.propertyCardViews.tr(
                        namedArgs: {
                          'count': widget.property.viewsCount.toStringAsFixed(
                            1,
                          ),
                        },
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    LocaleKeys.propertyDetailsListedOn.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.property.createdAt
                        .toIso8601String()
                        .split('T')
                        .first,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                LocaleKeys.propertyDetailsBedrooms.tr(),
                widget.property.bedrooms.toString(),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                LocaleKeys.propertyDetailsBaths.tr(),
                widget.property.bathrooms.toString(),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                LocaleKeys.propertyDetailsArea.tr(),
                LocaleKeys.propertyDetailsAreaValue.tr(
                  namedArgs: {'area': widget.property.squareMeters.toString()},
                ),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                LocaleKeys.propertyDetailsBeds.tr(),
                widget.property.beds.toString(),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                LocaleKeys.propertyDetailsMaxOccupants.tr(),
                widget.property.maxOccupants.toString(),
              ),
              const Divider(height: 16),
              _buildDetailRow(
                LocaleKeys.propertyDetailsSharedProperty.tr(),
                widget.property.isShared
                    ? LocaleKeys.propertyDetailsYes.tr()
                    : LocaleKeys.propertyDetailsNo.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsAboutProperty.tr(),
          style: AppTextStyles.titleLarge,
        ),
        CustomGeneralContainer(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Text(
            widget.property.description,
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsAmenities.tr(),
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9 > 1000
              ? 1000
              : MediaQuery.of(context).size.width * 0.9,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.property.amenities
                .map(
                  (amenity) => AmenityBox(
                    label: amenity.amenity.displayName,
                    borderColor: AppColors.primary,
                    boxColor: AppColors.onPrimary,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsHostedBy.tr(),
          style: AppTextStyles.titleLarge,
        ),
        CustomGeneralContainer(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ProfileImageWidget(
              imagePath: widget.property.hostedBy.profileImage,
            ),
            title: Text(
              widget.property.hostedBy.fullName,
              style: AppTextStyles.titleMedium,
            ),
            subtitle: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  LocaleKeys.propertyDetailsRating.tr(
                    namedArgs: {
                      'rating': widget.property.hostedBy.averageRating
                          .toString(),
                    },
                  ),
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  LocaleKeys.propertyDetailsPropertiesCount.tr(
                    namedArgs: {
                      'count': widget.property.hostedBy.propertiesCount
                          .toString(),
                    },
                  ),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                context.push(
                  AppRoutes.chatScreen,
                  extra: ChatScreenArguments(
                    userId: widget.property.hostedBy.id,
                  ),
                );
              },
              icon: const Icon(Icons.chat),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveRentersSection() {
    if (widget.property.activeRenters.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsActiveRenters.tr(),
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 12),
        ...widget.property.activeRenters.map((renter) {
          return CustomGeneralContainer(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ProfileImageWidget(
                imagePath: renter.profilePhoto,
                radius: 25,
              ),
              title: Text(renter.name, style: AppTextStyles.titleMedium),
              subtitle: renter.matchingPercentage != null
                  ? Text(
                      LocaleKeys.propertyDetailsMatching.tr(
                        namedArgs: {
                          'percentage': renter.matchingPercentage!
                              .toStringAsFixed(0),
                        },
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              trailing: IconButton(
                onPressed: () {
                  context.push(
                    AppRoutes.profileScreen,
                    extra: ProfileScreenArguments(userId: renter.id),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsRules.tr(),
          style: AppTextStyles.titleLarge,
        ),
        CustomGeneralContainer(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            children: widget.property.rules
                .map(
                  (rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            rule.text,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showBookingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return BookingBottomSheet(
          propertyId: widget.property.id,
          price: widget.property.price,
          rentalUnit: widget.property.rentalUnit,
        );
      },
    );
  }

  void _showMapDialog(BuildContext context, num lat, num lng) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  ShowMap(
                    mapController: MapController(),
                    selectedLocation: LatLng(lat.toDouble(), lng.toDouble()),
                    interactive: true,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentUserBookingRequests() {
    List<PropertyBookingRequestEntity> currentUserBookingRequests =
        widget.property.currentUserBookingRequests;
    return Column(
      children: [
        ...currentUserBookingRequests.map((request) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomGeneralContainer(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Text(
                    LocaleKeys.propertyDetailsPaymentFrequency.tr(
                      namedArgs: {
                        'frequency': request.paymentFrequency.displayName,
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocaleKeys.propertyDetailsDates.tr(
                      namedArgs: {
                        'start': request.startDate.toIso8601String().split(
                          'T',
                        )[0],
                        'end': request.endDate.toIso8601String().split('T')[0],
                      },
                    ),
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  CustomGeneralButton(
                    onPressed: () {
                      context.read<BookingContractCubit>().cancelBooking(
                        bookingId: request.bookingRequestId,
                      );
                      setState(() {
                        currentUserBookingRequests.remove(request);
                      });
                    },
                    text: LocaleKeys.propertyButtonsCancel.tr(),
                    backgroundColor: AppColors.surface,
                    borderColor: AppColors.primary,
                    textColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOwnerExtrasSection() {
    final extras = widget.property.ownerExtras!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              LocaleKeys.propertyDetailsOwnerWorkspace.tr(),
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomGeneralContainer(
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.propertyDetailsPropertyStatus.tr(),
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (extras.propertyStatus != null)
                    StatusBadgeWidget(status: extras.propertyStatus!),
                ],
              ),
            ),
          ],
        ),
        if (extras.pendingBookingRequests.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            LocaleKeys.propertyDetailsPendingRequests.tr(
              namedArgs: {
                'count': extras.pendingBookingRequests.length.toString(),
              },
            ),
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...extras.pendingBookingRequests.map((request) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomGeneralContainer(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfileImageWidget(
                          imagePath: request.renterProfileImage,
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            request.renterName,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.message,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            context.push(
                              AppRoutes.chatScreen,
                              extra: ChatScreenArguments(
                                userId: request.renterId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      LocaleKeys.propertyDetailsPaymentFrequency.tr(
                        namedArgs: {
                          'frequency': request.paymentFrequency.displayName,
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      LocaleKeys.propertyDetailsDates.tr(
                        namedArgs: {
                          'start': request.startDate.toIso8601String().split(
                            'T',
                          )[0],
                          'end': request.endDate.toIso8601String().split(
                            'T',
                          )[0],
                        },
                      ),
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomGeneralButton(
                            onPressed: () {
                              context
                                  .read<BookingContractCubit>()
                                  .createContract(
                                    bookingRequestId: request.bookingRequestId,
                                  );
                              setState(() {
                                extras.pendingBookingRequests.remove(request);
                              });
                            },
                            text: LocaleKeys.propertyDetailsAccept.tr(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomGeneralButton(
                            onPressed: () {
                              context
                                  .read<BookingContractCubit>()
                                  .cancelBooking(
                                    bookingId: request.bookingRequestId,
                                  );
                              setState(() {
                                extras.pendingBookingRequests.remove(request);
                              });
                            },
                            text: LocaleKeys.propertyDetailsDecline.tr(),
                            backgroundColor: AppColors.surface,
                            borderColor: AppColors.primary,
                            textColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        if (extras.contractsHistory.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            LocaleKeys.propertyDetailsContractsHistory.tr(
              namedArgs: {'count': extras.contractsHistory.length.toString()},
            ),
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...extras.contractsHistory.map((contract) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomGeneralContainer(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        contract.renterName,
                        style: AppTextStyles.titleMedium,
                      ),
                      subtitle: Wrap(
                        spacing: 4,
                        children: [
                          StatusBadgeWidget(status: contract.contractStatus),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.propertyDetailsExpiryDate.tr(
                              namedArgs: {
                                'date': DateFormatter.format(
                                  contract.expiryDate,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat, color: AppColors.primary),
                        onPressed: () {
                          context.push(
                            AppRoutes.chatScreen,
                            extra: ChatScreenArguments(
                              userId: contract.renterId,
                            ),
                          );
                        },
                      ),
                    ),

                    Row(
                      children: [
                        if (contract.contractStatus.name.toLowerCase() ==
                            'pending') ...[
                          Expanded(
                            child: CustomGeneralButton(
                              text: LocaleKeys.propertyButtonsCancel.tr(),
                              onPressed: () {
                                context
                                    .read<BookingContractCubit>()
                                    .cancelContract(
                                      contractId: contract.contractId,
                                    );
                              },
                              backgroundColor: AppColors.surface,
                              borderColor: AppColors.primary,
                              textColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: CustomGeneralButton(
                            text: LocaleKeys.propertyDetailsContract.tr(),
                            onPressed: () {
                              context.push(
                                AppRoutes.contractScreen,
                                extra: ContractScreenArguments(
                                  contractId: contract.contractId,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildReviewsSection() {
    final currentUserId = SharedPreferencesHelper.getString(
      LocalStorageVariables.userId,
    );
    final avgRating = widget.property.averageRating;
    final isAllowed = widget.property.isUserAllowedToFeedback;
    final hasUserFeedback =
        widget.property.currentUserRating != null ||
        widget.property.comments.any(
          (comment) => comment.commenterId == currentUserId,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.propertyDetailsReviewsCount.tr(
                namedArgs: {'count': widget.property.commentsCount.toString()},
              ),
              style: AppTextStyles.titleLarge,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.available,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  avgRating.toStringAsFixed(1),
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Add feedback section
        if (isAllowed && !hasUserFeedback) _buildAddFeedbackSection(),
        const SizedBox(height: 16),
        // List of reviews
        if (widget.property.comments.isNotEmpty)
          Builder(
            builder: (context) {
              final comments = List<PropertyCommentDetailsEntity>.from(
                widget.property.comments,
              );
              comments.sort((a, b) {
                final aIsMine = a.commenterId == currentUserId;
                final bIsMine = b.commenterId == currentUserId;
                if (aIsMine && !bIsMine) return -1;
                if (!aIsMine && bIsMine) return 1;
                return 0;
              });
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final isMyComment = comment.commenterId == currentUserId;
                  return _buildReviewItem(comment, isMyComment);
                },
              );
            },
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                LocaleKeys.propertyDetailsNoReviewsYet.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(
    PropertyCommentDetailsEntity comment,
    bool isMyComment,
  ) {
    final isEditing = _editingComment?.commentId == comment.commentId;

    final reviewWidget = CustomGeneralContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileImageWidget(
                imagePath: comment.commenterProfileImage,
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.commenterFullName,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                    ),
                    if (comment.rating != null)
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < comment.rating!
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 14,
                            color: AppColors.available,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    comment.createdAt.toIso8601String().split('T')[0],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (isMyComment)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _editingComment = comment;
                              _editCommentController.text = comment.content;
                              _editingRating =
                                  comment.rating ??
                                  widget.property.currentUserRating ??
                                  0;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            _showDeleteCommentConfirmation(comment);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),

          // Stay Info
          if (comment.stayInfo.checkIn != null ||
              comment.stayInfo.checkOut != null ||
              comment.stayInfo.isContractActive) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      [
                        if (comment.stayInfo.checkIn != null)
                          LocaleKeys.propertyDetailsStayFrom.tr(
                            namedArgs: {
                              'date': DateFormatter.format(
                                comment.stayInfo.checkIn!,
                              ),
                            },
                          ),
                        if (comment.stayInfo.checkOut != null)
                          LocaleKeys.propertyDetailsStayTo.tr(
                            namedArgs: {
                              'date': DateFormatter.format(
                                comment.stayInfo.checkOut!,
                              ),
                            },
                          ),
                        if (comment.stayInfo.isContractActive)
                          LocaleKeys.propertyDetailsActiveTenant.tr(),
                      ].join(" • "),
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          if (isEditing) ...[
            Form(
              key: _editFeedbackFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: _editCommentController,
                    hintText: LocaleKeys.propertyDetailsUpdateCommentHint.tr(),
                    type: CustomTextFormFieldType.text,
                    maxLines: 3,
                    minLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return LocaleKeys.propertyDetailsCommentRequired.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormField<int>(
                    initialValue: _editingRating == 0 ? null : _editingRating,
                    validator: (value) {
                      if (value == null || value == 0) {
                        return LocaleKeys.propertyDetailsRatingRequired.tr();
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LocaleKeys.propertyDetailsYourRatingLabel.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(5, (index) {
                                  final ratingValue = index + 1;
                                  final isLit = _editingRating >= ratingValue;
                                  return GestureDetector(
                                    onTap: _isSubmitting
                                        ? null
                                        : () {
                                            setState(() {
                                              _editingRating = ratingValue;
                                            });
                                            state.didChange(ratingValue);
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0,
                                      ),
                                      child: Icon(
                                        isLit
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: AppColors.available,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          if (state.hasError) ...[
                            const SizedBox(height: 4),
                            Text(
                              state.errorText!,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.error,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _editingComment = null;
                            _editCommentController.clear();
                            _editingRating = 0;
                          });
                        },
                        child: Text(
                          LocaleKeys.propertyDetailsCancel.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                if (_editFeedbackFormKey.currentState!
                                    .validate()) {
                                  context.read<PropertyCubit>().updateFeedback(
                                    propertyId: widget.property.id,
                                    rating: _editingRating,
                                    content: _editCommentController.text.trim(),
                                  );
                                }
                              },
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                LocaleKeys.propertyDetailsSave.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              comment.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );

    Offset tapPosition = Offset.zero;

    if (isMyComment) {
      return reviewWidget;
    } else {
      return GestureDetector(
        onTapDown: (details) {
          tapPosition = details.globalPosition;
        },
        onTap: () async {
          final overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final result = await showMenu<String>(
            context: context,
            position: RelativeRect.fromRect(
              Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
              Offset.zero & overlay.size,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.surface,
            elevation: 8,
            items: [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    const Icon(
                      Icons.report_gmailerrorred_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      LocaleKeys.propertyDetailsReportComment.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          if (result == 'report') {
            showReportDialog(
              context,
              reportableType:
                  EnumHelper.getEnum(
                    context,
                    EnumType.reportableTypes,
                  )?.firstWhere(
                    (e) => e.name.toLowerCase() == 'propertycomment',
                    orElse: () => EnumItem(
                      id: 0,
                      name: 'propertycomment',
                      displayName: 'Property Comment',
                    ),
                  ) ??
                  EnumItem(
                    id: 0,
                    name: 'propertycomment',
                    displayName: 'Property Comment',
                  ),
              reportableTargetId: comment.commentId.toString(),
            );
          }
        },
        child: reviewWidget,
      );
    }
  }

  Widget _buildAddFeedbackSection() {
    return Center(
      child: CustomGeneralContainer(
        margin: EdgeInsets.zero,
        child: Form(
          key: _addFeedbackFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyDetailsShareExperience.tr(),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Star selector
              FormField<int>(
                initialValue: _selectedRating == 0 ? null : _selectedRating,
                validator: (value) {
                  if (value == null || value == 0) {
                    return LocaleKeys.propertyDetailsRatingRequired.tr();
                  }
                  return null;
                },
                builder: (FormFieldState<int> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.propertyDetailsYourRatingLabel.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: List.generate(5, (index) {
                              final ratingValue = index + 1;
                              final isLit = _selectedRating >= ratingValue;
                              return GestureDetector(
                                onTap: _isSubmitting
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedRating = ratingValue;
                                        });
                                        state.didChange(ratingValue);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 1.0,
                                      end: isLit ? 1.2 : 1.0,
                                    ),
                                    duration: const Duration(milliseconds: 150),
                                    builder: (context, scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: Icon(
                                          isLit
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          color: AppColors.available,
                                          size: 28,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      if (state.hasError) ...[
                        const SizedBox(height: 4),
                        Text(
                          state.errorText!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.error,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Comment box
              CustomTextFormField(
                controller: _commentController,
                hintText: LocaleKeys.propertyDetailsWriteReviewHere.tr(),
                type: CustomTextFormFieldType.text,
                maxLines: 4,
                minLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.propertyDetailsCommentRequired.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_addFeedbackFormKey.currentState!.validate()) {
                            context.read<PropertyCubit>().submitFeedback(
                              propertyId: widget.property.id,
                              rating: _selectedRating,
                              content: _commentController.text.trim(),
                            );
                          }
                        },
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          LocaleKeys.propertyDetailsSubmitReview.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteCommentConfirmation(PropertyCommentDetailsEntity comment) {
    myShowDialog(
      context,
      title: LocaleKeys.propertyDetailsDeleteCommentTitle.tr(),
      content: LocaleKeys.propertyDetailsDeleteCommentConfirm.tr(),
      onConfirm: () {
        context.read<PropertyCubit>().deleteFeedback(
          propertyId: widget.property.id,
        );
      },
      confirmText: LocaleKeys.propertyDetailsDelete.tr(),
    );
  }
}
