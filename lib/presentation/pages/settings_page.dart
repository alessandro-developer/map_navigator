import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:map_navigator/business_logic.dart';
import 'package:map_navigator/presentation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();

    context.read<PermissionCubit>().handlePermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionCubit, PermissionState>(
      listenWhen: (previous, current) => previous.permissionsGranted != current.permissionsGranted,
      listener:
          (context, state) => switch (state.permissionsStatus) {
            FormzSubmissionStatus.inProgress => context.loaderOverlay.show(),
            FormzSubmissionStatus.success => {Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (Route<dynamic> route) => false)},
            FormzSubmissionStatus.failure => {
              context.loaderOverlay.hide(),
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(backgroundColor: Colors.grey, content: Text('Permessi di localizzazione non accettati.'))),
            },
            (_) => context.loaderOverlay.hide(),
          },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Impostazioni Localizzazione')),
          body:
              state.permissionsStatus == FormzSubmissionStatus.inProgress
                  ? Container()
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('L\'app necessita dei permessi di localizzazione per funzionare.', textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        if (state.openAppSettings == true)
                          ElevatedButton(
                            onPressed: () {
                              context.read<PermissionCubit>().openAppSettings();
                            },
                            child: Text('Apri Impostazioni App'),
                          )
                        else if (state.openLocationSettings == true)
                          ElevatedButton(
                            onPressed: () {
                              context.read<PermissionCubit>().openLocationSettings();
                            },
                            child: Text('Apri Impostazioni Posizione'),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              context.read<PermissionCubit>().handlePermission();
                            },
                            child: const Text('Riprova ad accettare i permessi'),
                          ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
