import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsSates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          var cubit = NewsCubit.get(ctx);
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: cubit.bottomTap,
              currentIndex: cubit.curentIndex,
              onTap: (index) {
                cubit.changeScreen(index);
              },
            ),
            body: cubit.screens[cubit.curentIndex],
          );
        },
      ),
    );
  }
}
