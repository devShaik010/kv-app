import 'package:flutter/material.dart';
import 'package:kisanverse/screens/model/farmer_info_input.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FarmerInfo? _farmerInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmerInfo();
  }

  Future<void> _loadFarmerInfo() async {
    final info = await loadFarmerInfo();
    setState(() {
      _farmerInfo = info;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _farmerInfo?.farmName ?? 'Farm',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FarmerInfoInput(),
                                ),
                              ).then((_) => _loadFarmerInfo());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Profile Avatar
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Farmer Name
                      Center(
                        child: Text(
                          _farmerInfo?.name ?? 'Farmer',
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
                          _farmerInfo?.farmName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Information Cards
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        value: _farmerInfo?.email ?? 'N/A',
                        color: const Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        value: _farmerInfo?.phone ?? 'N/A',
                        color: const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        title: 'Location',
                        value: _farmerInfo?.location ?? 'N/A',
                        color: const Color(0xFFFF5722),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.straighten_outlined,
                        title: 'Farm Size',
                        value: _farmerInfo?.farmSize ?? 'N/A',
                        color: const Color(0xFF9C27B0),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.stars_outlined,
                        title: 'Experience',
                        value: _farmerInfo?.experience ?? 'N/A',
                        color: const Color(0xFFFFC107),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}