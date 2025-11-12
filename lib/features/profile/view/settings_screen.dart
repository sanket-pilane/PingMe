import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocProvider(
        create: (context) =>
            SettingsCubit(context.read<AuthRepository>(), user),
        child: const SettingsForm(),
      ),
    );
  }
}

class SettingsCubit extends Cubit<UserModel> {
  SettingsCubit(this._authRepository, UserModel initialUser)
    : super(initialUser);

  final AuthRepository _authRepository;

  void usernameChanged(String username) {
    emit(state.copyWith(username: username));
  }

  Future<void> saveProfile() async {
    await _authRepository.updateUserProfile(state);
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: context.read<SettingsCubit>().state.username,
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<SettingsCubit>().state.email;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            onChanged: (username) {
              context.read<SettingsCubit>().usernameChanged(username);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsCubit>().saveProfile();
              Navigator.of(context).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
