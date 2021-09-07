import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_preferences.dart';
import '../structures/localizations.dart';

import '../widgets/custom_sliver_app_bar.dart';

import '../words.dart';

enum preferences { SystemPreference, Light, Dark }

class SettingsPage extends StatelessWidget {
  static const tag = "settings_page";

  @override
  Widget build(BuildContext context) {
    final userPreferences = Provider.of<UserPreference>(context);
    bool systemPreferenceUiSwitch = userPreferences.systemPreferenceUiSwitch;
    bool lightSwitch = userPreferences.lightSwitch;
    bool darkSwitch = userPreferences.darkSwitch;

    bool systemPreferenceLanguageSwitch =
        userPreferences.systemPreferenceLanguageSwitch;
    bool enSwitch = userPreferences.enSwitch;
    bool frSwitch = userPreferences.frSwitch;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        CustomSliverAppBar(
          title: AppLocalizations.of(context).translate(Words.themePreference),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(AppLocalizations.of(context)
                        .translate(Words.systemPreferenceUi)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: systemPreferenceUiSwitch,
                    onChanged: (newSwitchValue) {
                      systemPreferenceUiSwitch
                          ? print("Blocked")
                          : userPreferences.changeUiPreferences(0);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(AppLocalizations.of(context)
                        .translate(Words.lightMode)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: lightSwitch,
                    onChanged: (newSwitchValue) {
                      lightSwitch
                          ? print("Blocked")
                          : userPreferences.changeUiPreferences(1);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        AppLocalizations.of(context).translate(Words.darkMode)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: darkSwitch,
                    onChanged: (newSwitchValue) {
                      darkSwitch
                          ? print("Blocked")
                          : userPreferences.changeUiPreferences(2);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
