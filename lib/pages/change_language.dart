import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_preferences.dart';
import '../structures/localizations.dart';

import '../widgets/custom_sliver_app_bar.dart';

import '../words.dart';

enum preferences { SystemPreference, Light, Dark }

class ChangeLanguagePage extends StatelessWidget {
  static const tag = "change_language_page";

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
          title: AppLocalizations.of(context).translate(Words.changeLanguage),
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
                        .translate(Words.systemPreferenceLanguage)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: systemPreferenceLanguageSwitch,
                    onChanged: (newSwitchValue) {
                      systemPreferenceLanguageSwitch
                          ? print("Blocked")
                          : userPreferences.changeLanguagePreferences(0);
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
                        AppLocalizations.of(context).translate(Words.english)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: enSwitch,
                    onChanged: (newSwitchValue) {
                      enSwitch
                          ? print("Blocked")
                          : userPreferences.changeLanguagePreferences(1);
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
                        AppLocalizations.of(context).translate(Words.french)),
                  ),
                  Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: frSwitch,
                    onChanged: (newSwitchValue) {
                      frSwitch
                          ? print("Blocked")
                          : userPreferences.changeLanguagePreferences(2);
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
