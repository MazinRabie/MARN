import 'package:MARN/features/static_screens/data/models/expansion_model.dart';
import 'package:MARN/features/static_screens/presentation/widgets/expansion_item_widget.dart';
import 'package:flutter/material.dart';

class ExpansionListItemWidget extends StatelessWidget {
  const ExpansionListItemWidget({
    super.key,
    required this.list,
    this.itemKeys,
  });
  final List<ExpansionModel> list;
  final Map<String, GlobalKey>? itemKeys;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return ExpansionItemWidget(
          key: itemKeys?[item.title] ??= GlobalKey(),
          item: item,
        );
      },
    );
  }
}
