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
    emit(state.copyWith(username: username));
  }

  // --- ADDED METHODS ---
  void onFullNameChanged(String fullName) {
    emit(state.copyWith(fullName: fullName));
  }

  void onBioChanged(String bio) {
    emit(state.copyWith(bio: bio));
  }
  // --- END OF ADD ---

  Future<void> onSave() async {
    try {
      // --- THIS IS THE FIX ---
      // We now pass named arguments, not the whole state object.
      // --- UPDATED ---
      await _authRepository.updateUserProfile(
        uid: state.uid,
        username: state.username,
        fullName: state.fullName, // Pass new data
        bio: state.bio, // Pass new data
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

    // --- UPDATED to listen to the whole user object ---
    final user = context.select((SettingsCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: user.username, // --- UPDATED ---
              onChanged: (value) => cubit.onUsernameChanged(value),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // --- ADDED FIELDS ---
            TextFormField(
              initialValue: user.fullName,
              onChanged: (value) => cubit.onFullNameChanged(value),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.bio,
              onChanged: (value) => cubit.onBioChanged(value),
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            // --- END OF ADD ---
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
