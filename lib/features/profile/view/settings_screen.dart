import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';

class SettingsCubit extends Cubit<UserModel> {
  final AuthRepository _authRepository;

  SettingsCubit({
    required UserModel initialUser,
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
       super(initialUser);

  void onUsernameChanged(String username) {
    // This will now work because user_model.dart has copyWith
    emit(state.copyWith(username: username));
  }

  Future<void> onSave() async {
    try {
      // --- THIS IS THE FIX ---
      // We now pass named arguments, not the whole state object.
      await _authRepository.updateUserProfile(
        uid: state.uid,
        username: state.username,
      );
      // --- END OF FIX ---
    } catch (e) {
      // Handle error
    }
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (context) => SettingsCubit(
        initialUser: authUser,
        authRepository: context.read<AuthRepository>(),
      ),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final username = context.select(
      (SettingsCubit cubit) => cubit.state.username,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: username,
              onChanged: (value) => cubit.onUsernameChanged(value),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                cubit.onSave();
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
