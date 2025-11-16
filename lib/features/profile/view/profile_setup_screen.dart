import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/home/view/home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // --- UPDATED CONTROLLERS ---
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();
  // --- END OF UPDATE ---

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose(); // --- ADDED ---
    _bioController.dispose(); // --- ADDED ---
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated &&
            state.user.username.isNotEmpty) {
          // Move to home and remove previous screens
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (r) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Setup Your Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome! Complete your profile to continue.', // --- UPDATED ---
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController, // --- UPDATED ---
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // --- ADDED FIELDS ---
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio (Optional)',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              // --- END OF ADD ---
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // --- UPDATED LOGIC ---
                  if (_usernameController.text.isNotEmpty &&
                      _fullNameController.text.isNotEmpty) {
                    context.read<AuthRepository>().updateUserProfile(
                      uid: authUser.uid,
                      username: _usernameController.text.trim(),
                      fullName: _fullNameController.text.trim(),
                      bio: _bioController.text.trim(),
                    );
                    // Firestore write will update the stream -> AuthBloc -> triggers the listener above
                  }
                },
                child: const Text('Save and Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
