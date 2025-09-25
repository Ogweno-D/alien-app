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

  InputDecoration _inputDecoration(String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: label,
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.tertiary, width: 2),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurface),
      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
    );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                elevation: 6, // shadow depth
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: "fullName",
                          decoration: _inputDecoration("Full Name"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: "email",
                          decoration: _inputDecoration("Email"),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderDropdown(
                          name: "favoriteCategory",
                          decoration: _inputDecoration("Favorite Category"),
                          items: ["Nature", "Cars", "Animals", "Technology"]
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: "password",
                          decoration: _inputDecoration("Password"),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(6),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: "confirmPassword",
                          decoration: _inputDecoration("Confirm Password"),
                          obscureText: true,
                          validator: (val) {
                            final password =
                                _formKey.currentState?.fields["password"]?.value;
                            if (val != password) return "Passwords do not match";
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: state.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: 180,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  final data = _formKey.currentState!.value;
                                  await ref
                                      .read(profileFormProvider.notifier)
                                      .saveFormData(data);
                                  ref
                                      .read(profileFormProvider.notifier)
                                      .submitForm(data);
                                }
                              },
                              child: const Text(
                                  "Submit",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
