import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npng/logic/cubit/current_tab_cubit.dart';

import 'package:npng/generated/l10n.dart';
import 'package:npng/presentation/screens/calculators/calc_main_screen.dart';
import 'package:npng/presentation/screens/exercises/exercises_screen.dart';
import 'package:npng/presentation/screens/log/log_calendar_screen.dart';
import 'package:npng/presentation/screens/programs/programs_screen.dart';
import 'package:npng/presentation/screens/settings/setings_screen.dart';
import 'package:npng/presentation/screens/workout/workout_00_start_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> pageList = <Widget>[
    const WorkoutStartScreen(),
    const ExercisesScreen(),
    const LogCalendarScreen(),
    const CalcMainScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    String title = 'NpNg';

    return BlocListener<CurrentTabCubit, CurrentTabState>(
      listener: (context, state) {
        if (state is CurrentTabLoaded) {
          switch (state.selectedIndex) {
            case 0:
              title = S.of(context).pageWorkout;
              break;
            case 1:
              title = S.of(context).pageExerciseTitle;
              break;
            case 2:
              title = S.of(context).log;
              break;
            case 3:
              title = S.of(context).calculate;
              break;
            case 4:
              title = S.of(context).settings;
              break;
            default:
          }
        }
      },
      child: BlocBuilder<CurrentTabCubit, CurrentTabState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.fitness_center_rounded),
                  label: S.of(context).pageWorkout,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.directions_run_rounded),
                  label: S.of(context).pageExerciseTitle,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: S.of(context).log,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.gas_meter_rounded),
                  label: S.of(context).calculate,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  label: S.of(context).settings,
                ),
              ],
              currentIndex: state is CurrentTabLoaded ? state.selectedIndex : 0,
              onTap: (int index) {
                context.read<CurrentTabCubit>().saveCurrentIndex(index);
              },
            ),
            appBar: AppBar(
              title: Text(title),
              actions: <Widget>[
                if ((state is CurrentTabLoaded ? state.selectedIndex : 0) == 0)
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    icon: const Icon(Icons.checklist_rounded),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgramsScreen(),
                      ),
                    ),
                  )
              ],
            ),
            body: IndexedStack(
              index: state is CurrentTabLoaded ? state.selectedIndex : 0,
              children: pageList,
            ),
          );
        },
      ),
    );
  }
}
