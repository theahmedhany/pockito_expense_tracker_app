import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/responsive_helpers/size_provider.dart';
import 'core/responsive_helpers/sizer_helper_extension.dart';
import 'features/home/business_logic/cubit/expense_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';

import 'core/database/hive_database.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("EXPENSE_DATABASE");

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCubit(HiveDatabase()),
      child: SizeProvider(
        baseSize: const Size(360, 690),
        height: context.screenHeight,
        width: context.screenWidth,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      ),
    );
  }
}
