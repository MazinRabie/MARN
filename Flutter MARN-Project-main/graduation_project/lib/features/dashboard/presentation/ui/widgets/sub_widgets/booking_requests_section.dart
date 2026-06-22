import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/booking_request_card.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_section_header.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BookingRequestsSection extends StatelessWidget {
  final List<OwnerPendingBookingRequestEntity>? ownerPendingRequests;
  final List<RenterPendingBookingRequestEntity>? renterPendingRequests;

  const BookingRequestsSection({
    super.key,
    this.ownerPendingRequests,
    this.renterPendingRequests,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingContractCubit, BookingContractState>(
      listener: (context, state) {
        if (state is CancelBookingSuccess) {
          buildSnackBar(context, message: state.message);
        }
        if (state is StartChatSuccess) {
          context.push(
            AppRoutes.chatScreen,
            extra: ChatScreenArguments(userId: state.chatUserId),
          );
        }
        if (state is CancelBookingFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },
      buildWhen: (previous, current) {
        return current is CancelBookingSuccess;
      },
      builder: (context, state) {
        if (state is CancelBookingSuccess) {
          return SliverMainAxisGroup(slivers: _buildBookingRequestsSlivers());
        }
        return SliverMainAxisGroup(slivers: _buildBookingRequestsSlivers());
      },
    );
  }

  List<Widget> _buildBookingRequestsSlivers() {
    final List<Widget> slivers = [];

    // Owner Pending Requests
    if (ownerPendingRequests != null && ownerPendingRequests!.isNotEmpty) {
      slivers.add(
        DashboardSectionHeader(
          title: LocaleKeys.dashboardManagementBookingRequestsCount.tr(
            namedArgs: {'count': ownerPendingRequests!.length.toString()},
          ),
        ),
      );
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final request = ownerPendingRequests![index];
            return BookingRequestCard(request: request);
          }, childCount: ownerPendingRequests!.length),
        ),
      );
    }

    // Renter Sent Requests
    if (renterPendingRequests != null && renterPendingRequests!.isNotEmpty) {
      slivers.add(
        DashboardSectionHeader(
          title: LocaleKeys.dashboardManagementPropertiesBookedCount.tr(
            namedArgs: {'count': renterPendingRequests!.length.toString()},
          ),
        ),
      );
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final request = renterPendingRequests![index];
            return BookingRequestCard(request: request);
          }, childCount: renterPendingRequests!.length),
        ),
      );
    }

    return slivers;
  }
}
