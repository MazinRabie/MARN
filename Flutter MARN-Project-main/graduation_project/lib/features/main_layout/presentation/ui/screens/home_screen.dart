import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/search_widget.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/build_skeleton.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ViewerPropertyCardEntity> recommendedProperties = [];
  List<ViewerPropertyCardEntity> searchedProperties = [];

  PropertySearchParameters searchParams = PropertySearchParameters(
    page: 1,
    pageSize: 20,
  );
  final TextEditingController searchController = TextEditingController();
  final ScrollController _searchScrollController = ScrollController();
  bool _isPaginationLoading = false;
  bool _hasReachedMax = false;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    // Fetch recommendedProperties list on init
    context.read<PropertyCubit>().recommendedProperties();
    _searchScrollController.addListener(_onSearchScroll);
  }

  void _onSearchScroll() {
    if (_searchScrollController.position.pixels >=
            _searchScrollController.position.maxScrollExtent * 0.7 &&
        !_isPaginationLoading &&
        !_hasReachedMax) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    _isPaginationLoading = true;
    setState(() {
      searchParams = searchParams.copyWith(page: (searchParams.page ?? 1) + 1);
    });
    context.read<PropertyCubit>().searchProperties(
      searchParams,
      isPagination: true,
    );
  }

  @override
  void dispose() {
    _searchScrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return PropertyFilterBottomSheet(
              scrollController: scrollController,
              initialParams: searchParams,
              onApply: (params) {
                setState(() {
                  searchParams = params.copyWith(page: 1);
                  _hasReachedMax = false;
                });
                context.read<PropertyCubit>().searchProperties(searchParams);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            SearchWidget(
              hintText: LocaleKeys.mainLayoutHomeSearchProperties.tr(),
              controller: searchController,
              actionWidget: IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.primary),
                onPressed: _openFilterBottomSheet,
              ),
              onPressed: (value) {
                setState(() {
                  searchParams = searchParams.copyWith(
                    keyword: value,
                    page: 1,
                    pageSize: 20,
                  );
                  _hasReachedMax = false;
                });
                context.read<PropertyCubit>().searchProperties(searchParams);
              },
              onPressedClose: () {
                context.read<PropertyCubit>().recommendedProperties();
              },
            ),
            BlocConsumer<PropertyCubit, PropertyState>(
              listener: (context, state) {
                if (state is PropertySearchFailure) {
                  _isPaginationLoading = false;
                  buildSnackBar(
                    context,
                    isError: true,
                    message: state.errorMessage,
                  );
                }
                if (state is PropertyRecommendedPropertiesFailure) {
                  buildSnackBar(
                    context,
                    isError: true,
                    message: state.errorMessage,
                  );
                }
                if (state is PropertySearchSuccess) {
                  _isPaginationLoading = false;
                  if (state.isPagination) {
                    searchedProperties.addAll(state.properties);
                  } else {
                    searchedProperties = state.properties;
                  }
                  _hasReachedMax = state.hasReachedMax;
                  _totalCount = state.totalCount;
                }
                if (state is PropertyRecommendedPropertiesSuccess) {
                  recommendedProperties = state.properties;
                }
              },
              buildWhen: (previous, current) {
                return current is PropertySearchLoading ||
                    current is PropertySearchPaginationLoading ||
                    current is PropertySearchSuccess ||
                    current is PropertySearchFailure ||
                    current is PropertyRecommendedPropertiesLoading ||
                    current is PropertyRecommendedPropertiesSuccess;
              },
              builder: (context, state) {
                if (state is PropertySearchLoading ||
                    state is PropertyRecommendedPropertiesLoading) {
                  return Expanded(child: buildSkeleton());
                }

                return Expanded(
                  child: Column(
                    children: [
                      if (state is PropertySearchSuccess ||
                          state is PropertySearchPaginationLoading ||
                          (state is PropertySearchFailure &&
                              searchedProperties.isNotEmpty)) ...[
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              setState(() {
                                searchParams = searchParams.copyWith(page: 1);
                                _hasReachedMax = false;
                              });
                              context.read<PropertyCubit>().searchProperties(
                                searchParams,
                              );
                            },
                            child: ListView.builder(
                              controller: _searchScrollController,
                              itemCount: searchedProperties.length + 1 + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _title(
                                    "${LocaleKeys.mainLayoutHomeSearchResult.tr()} ($_totalCount)",
                                  );
                                }

                                if (index - 1 < searchedProperties.length) {
                                  final property =
                                      searchedProperties[index - 1];
                                  return PropertyCard(
                                    property: property,
                                    index: index - 1,
                                  );
                                } else {
                                  if (searchedProperties.isEmpty)
                                    return const SizedBox.shrink();
                                  if (_hasReachedMax) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "No more results",
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],

                      if (state is PropertyRecommendedPropertiesSuccess) ...[
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              context
                                  .read<PropertyCubit>()
                                  .recommendedProperties();
                            },
                            child: ListView.builder(
                              itemCount: recommendedProperties.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _title(
                                    LocaleKeys.mainLayoutHomeRecommendedForYou
                                        .tr(),
                                  );
                                }

                                final property =
                                    recommendedProperties[index - 1];

                                return PropertyCard(
                                  property: property,
                                  index: index - 1,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return SizedBox(
      child: Center(child: Text(text, style: AppTextStyles.titleMedium)),
    );
  }
}
