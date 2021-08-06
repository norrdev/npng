import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:npng/config.dart';
import 'package:npng/pages/about_page.dart';
import 'package:npng/pages/exercises/exercises_page.dart';
import 'package:npng/generated/l10n.dart';
import 'package:npng/pages/log/log_start_page.dart';
import 'package:npng/pages/programs/programs_page.dart';
import 'package:npng/pages/workout/workout_00_start_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

class BottomBar extends StatelessWidget {
  BottomBar({this.initialActiveIndex});

  final int? initialActiveIndex;

  Future<String> _loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  /// Preparing data for "About" page
  void _getAboutPage(BuildContext context) async {
    Locale myLocale = Localizations.localeOf(context);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    //String buildNumber = packageInfo.buildNumber;

    String about = await _loadAsset("assets/texts/$myLocale/about.md");
    about = about.replaceAll('%version%', version);
    String history = await _loadAsset("CHANGELOG.md");

    // Navigator.push(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.fade,
    //     child: AboutPage(
    //       about: about,
    //       history: history,
    //       version: version,
    //     ),
    //   ),
    // );

    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            child: AboutPage(
              about: about,
              history: history,
              version: version,
            ),
            type: PageTransitionType.fade),
        (route) => false);

    // Navigator.pushAndRemoveUntil(context, mpPageRoute(
    //   builder: (context) {
    //     return AboutPage(
    //       about: about,
    //       history: history,
    //       version: version,
    //     );
    //   },
    // ), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.react,
      items: [
        TabItem(
            icon: Image.asset('assets/icons/icons8-gym-96.png'),
            title: S.of(context).pageWorkout),
        TabItem(
            icon: Image.asset('assets/icons/icons8-rules-96.png'),
            title: S.of(context).pageProgramsTitle),
        TabItem(
            icon: Image.asset('assets/icons/icons8-deadlift-96.png'),
            title: S.of(context).pageExerciseTitle),
        TabItem(
            icon: Image.asset('assets/icons/icons8-calendar-96.png'),
            title: S.of(context).log),
        TabItem(
            icon: Image.asset('assets/icons/icons8-info-96.png'),
            title: S.of(context).about),
      ],
      initialActiveIndex: this.initialActiveIndex,
      onTap: (int i) {
        if (i != this.initialActiveIndex) {
          switch (i) {
            case 0:
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: WorkoutStartPage(),
                    type: PageTransitionType.fade,
                  ),
                  (route) => false);
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: ProgramsPage(),
                    type: PageTransitionType.fade,
                  ),
                  (route) => false);
              break;
            case 2:
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: ExercisesPage(),
                    type: PageTransitionType.fade,
                  ),
                  (route) => false);
              break;
            case 3:
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: LogStartPage(),
                    type: PageTransitionType.fade,
                  ),
                  (route) => false);
              break;
            case 4:
              _getAboutPage(context);
              break;

            default:
          }
        }
      },
      color: (isApple)
          ? CupertinoTheme.of(context).primaryColor
          : Theme.of(context).appBarTheme.color,
      activeColor: (isApple)
          ? CupertinoTheme.of(context).primaryColor
          : Theme.of(context).bottomAppBarColor,
      backgroundColor: (isApple)
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).accentColor,
    );
  }
}
