import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/active_rental_card.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ActiveRentalsList extends StatelessWidget {
  final List<ActiveRentalCardEntity>? activeRentals;

  const ActiveRentalsList({super.key, required this.activeRentals});

  @override
  Widget build(BuildContext context) {
    if (activeRentals == null || activeRentals!.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return BlocConsumer<BookingContractCubit, BookingContractState>(
      listener: (context, state) {
        if (state is CancelContractSuccess) {
          buildSnackBar(context, message: state.message);
        }
        if (state is StartChatSuccess) {
          context.push(
            AppRoutes.chatScreen,
            extra: ChatScreenArguments(userId: state.chatUserId),
          );
        }
        if (state is CancelContractFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },
      buildWhen: (previous, current) {
        return current is CancelContractSuccess || current is SignContractSuccess;
      },
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final rental = activeRentals![index];
            return ActiveRentalCard(rental: rental);
          }, childCount: activeRentals!.length),
        );
      },
    );
  }
}
