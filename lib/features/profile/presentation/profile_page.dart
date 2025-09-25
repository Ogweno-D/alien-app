import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loadingLocalData = true;

  @override
  void initState() {
    super.initState();
    _loadSavedForm();
  }

  Future<void> _loadSavedForm() async {
    final savedData =
    await ref.read(profileFormProvider.notifier).loadFormData();
    if (savedData != null && _formKey.currentState != null) {
      _formKey.currentState!.patchValue(savedData);
    }
    setState(() => _loadingLocalData = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileFormProvider);

    ref.listen(profileFormProvider, (prev, next) {
      next.whenOrNull(
        data: (id) {
          if (id != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully! ID: $id")),
            );
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $err")),
          );
        },
      );
    });

    if (_loadingLocalData) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: [
              FormBuilderTextField(
                name: "fullName",
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
              FormBuilderTextField(
                name: "email",
                decoration: const InputDecoration(labelText: "Email"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              FormBuilderDropdown(
                name: "favoriteCategory",
                decoration: const InputDecoration(labelText: "Favorite Category"),
                items: ["Nature", "Cars", "Animals", "Technology"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: "password",
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ]),
              ),
              FormBuilderTextField(
                name: "confirmPassword",
                decoration: const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (val) {
                  final password = _formKey.currentState?.fields["password"]?.value;
                  if (val != password) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final data = _formKey.currentState!.value;

                    /// save locally before submit
                    await ref
                        .read(profileFormProvider.notifier)
                        .saveFormData(data);

                    /// submit online
                    ref
                        .read(profileFormProvider.notifier)
                        .submitForm(data);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
