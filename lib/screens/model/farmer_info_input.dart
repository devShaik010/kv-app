import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisanverse/screens/home.dart';
import 'dart:convert';

class FarmerInfoInput extends StatefulWidget {
  const FarmerInfoInput({Key? key}) : super(key: key);

  @override
  State<FarmerInfoInput> createState() => _FarmerInfoInputState();
}

class _FarmerInfoInputState extends State<FarmerInfoInput> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _farmNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _farmSizeController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _saveFarmerInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final farmerInfo = FarmerInfo(
        name: _nameController.text,
        farmName: _farmNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
        farmSize: _farmSizeController.text,
        experience: _experienceController.text,
      );

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('farmer_info', jsonEncode(farmerInfo.toJson()));
      await prefs.setBool('is_setup_complete', true);

      setState(() => _isLoading = false);

      if (mounted) {
        // Navigate to Home screen using direct navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      // Validate current step before moving
      bool isValid = false;
      switch (_currentStep) {
        case 0:
          isValid = _nameController.text.isNotEmpty && 
                   _farmNameController.text.isNotEmpty;
          break;
        case 1:
          isValid = _emailController.text.isNotEmpty && 
                   _phoneController.text.isNotEmpty;
          break;
      }

      if (isValid) {
        setState(() => _currentStep++);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
    } else {
      _saveFarmerInfo();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of 3',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${(((_currentStep + 1) / 3) * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 3,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.agriculture_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step Title
                      Center(
                        child: Text(
                          _getStepTitle(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          _getStepSubtitle(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Step Content
                      if (_currentStep == 0) _buildStep1(),
                      if (_currentStep == 1) _buildStep2(),
                      if (_currentStep == 2) _buildStep3(),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _currentStep == 2 ? 'Complete Setup' : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Welcome!';
      case 1:
        return 'Contact Information';
      case 2:
        return 'Farm Details';
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Let\'s start by knowing you better';
      case 1:
        return 'How can we reach you?';
      case 2:
        return 'Tell us about your farm';
      default:
        return '';
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Your Full Name',
          hint: 'e.g., John Doe',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _farmNameController,
          label: 'Farm Name',
          hint: 'e.g., Oakdale Ranch',
          icon: Icons.landscape_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your farm name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'e.g., farmer@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'e.g., +1 234 567 8900',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildTextField(
          controller: _locationController,
          label: 'Farm Location',
          hint: 'e.g., Uppal Kalan, Telangana',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your farm location';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _farmSizeController,
          label: 'Farm Size',
          hint: 'e.g., 50 Acres',
          icon: Icons.straighten_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your farm size';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _experienceController,
          label: 'Years of Experience',
          hint: 'e.g., 15 Years',
          icon: Icons.stars_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your experience';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// FarmerInfo model to store and retrieve farmer details
class FarmerInfo {
  final String name;
  final String farmName;
  final String email;
  final String phone;
  final String location;
  final String farmSize;
  final String experience;

  FarmerInfo({
    required this.name,
    required this.farmName,
    required this.email,
    required this.phone,
    required this.location,
    required this.farmSize,
    required this.experience,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'farmName': farmName,
      'email': email,
      'phone': phone,
      'location': location,
      'farmSize': farmSize,
      'experience': experience,
    };
  }

  factory FarmerInfo.fromJson(Map<String, dynamic> json) {
    return FarmerInfo(
      name: json['name'] ?? '',
      farmName: json['farmName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      farmSize: json['farmSize'] ?? '',
      experience: json['experience'] ?? '',
    );
  }
}

// Helper function to check if setup is complete
Future<bool> isSetupComplete() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_setup_complete') ?? false;
}

// Helper function to load farmer info
Future<FarmerInfo?> loadFarmerInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('farmer_info');
  if (jsonString != null) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return FarmerInfo.fromJson(data);
  }
  return null;
}
