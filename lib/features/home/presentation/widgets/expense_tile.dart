import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/responsive_helpers/size_provider.dart';
import '../../../../core/responsive_helpers/sizer_helper_extension.dart';
import '../../../../core/constants/app_colors.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final SlidableActionCallback deleteTapped;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizeProvider(
      baseSize: Size(250, 100),
      width: context.setMinSize(250),
      height: context.setMinSize(100),
      child: Builder(builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            bottom: context.setMinSize(12),
          ),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: deleteTapped,
                  backgroundColor: AppColors.kOrangeColor,
                  borderRadius: BorderRadius.circular(20),
                  icon: CupertinoIcons.delete,
                  label: 'Delete',
                  foregroundColor: Colors.white,
                ),
              ],
            ),
            child: _buildListTile(context),
          ),
        );
      }),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.shade300,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.setMinSize(8),
        vertical: context.setMinSize(4),
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            fontSize: context.setSp(18),
            color: Color(0xFF293B53),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${dateTime.day}/${dateTime.month}/${dateTime.year}',
          style: TextStyle(
            color: AppColors.kFontColor,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(
            context.setMinSize(6),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kBackgroundColor,
          ),
          child: Image.asset('assets/images/expense.png'),
        ),
        trailing: Text(
          '\£ $amount',
          style: TextStyle(
            fontSize: context.setSp(16),
            color: AppColors.kFontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
