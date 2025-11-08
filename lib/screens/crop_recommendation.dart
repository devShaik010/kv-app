import 'package:flutter/material.dart';
import 'package:kisanverse/controllers/api_service.dart';

class CropRecommendation extends StatefulWidget {
  const CropRecommendation({super.key});

  @override
  State<CropRecommendation> createState() => _CropRecommendationState();
}

class _CropRecommendationState extends State<CropRecommendation> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();

  bool _isLoading = false;
  CropRecommendationResponse? _result;

  @override
  void dispose() {
    nitrogenController.dispose();
    phosphorusController.dispose();
    potassiumController.dispose();
    temperatureController.dispose();
    humidityController.dispose();
    phController.dispose();
    rainfallController.dispose();
    super.dispose();
  }

  Future<void> _getCropRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final request = CropRecommendationRequest(
        nitrogen: double.parse(nitrogenController.text),
        phosphorus: double.parse(phosphorusController.text),
        potassium: double.parse(potassiumController.text),
        temperature: double.parse(temperatureController.text),
        humidity: double.parse(humidityController.text),
        ph: double.parse(phController.text),
        rainfall: double.parse(rainfallController.text),
      );

      final response = await _apiService.getCropRecommendation(request);

      setState(() {
        _result = response;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crop Recommendation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: _result != null ? _buildResultView() : _buildInputForm(),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Enter Soil & Climate Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Soil Nutrients Section
            _buildSectionHeader('Soil Nutrients (NPK)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Nitrogen (N)',
                    nitrogenController,
                    'kg/ha',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Phosphorus (P)',
                    phosphorusController,
                    'kg/ha',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField('Potassium (K)', potassiumController, 'kg/ha'),

            const SizedBox(height: 28),

            // Climate Section
            _buildSectionHeader('Climate Conditions'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Temperature',
                    temperatureController,
                    '°C',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('Humidity', humidityController, '%'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('pH Level', phController, '')),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('Rainfall', rainfallController, 'mm'),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _getCropRecommendation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Get Recommendation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final selectedCrop = _result!.selectedCrop;
    final recommendedCrops = _result!.recommendedCrops;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.verified, color: Colors.green.shade600, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Crops',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Best matches for your soil',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Recommended Crop (First one with higher confidence)
          _buildCropCard(
            cropName: recommendedCrops[0],
            confidence: selectedCrop.chance,
            isTopPick: true,
          ),
          const SizedBox(height: 16),

          // Other Recommended Crops
          if (recommendedCrops.length > 1) ...[
            Text(
              'Alternative Options',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...recommendedCrops
                .skip(1)
                .map(
                  (crop) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCropCard(
                      cropName: crop,
                      confidence: null,
                      isTopPick: false,
                    ),
                  ),
                ),
          ],

          const SizedBox(height: 24),

          // Try Again Button
          OutlinedButton.icon(
            onPressed: () => setState(() => _result = null),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            icon: const Icon(Icons.refresh, size: 20, color: Colors.black87),
            label: const Text(
              'Check Another Crop',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCropCard({
    required String cropName,
    required double? confidence,
    required bool isTopPick,
  }) {
    final imagePath = 'assets/crops/${cropName.toLowerCase()}.jpg';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isTopPick
            ? Border.all(color: Colors.green.shade300, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Crop Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: isTopPick ? 16 / 9 : 16 / 10,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),

          // Crop Details
          Padding(
            padding: EdgeInsets.all(isTopPick ? 20 : 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatCropName(cropName),
                        style: TextStyle(
                          fontSize: isTopPick ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (confidence != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(confidence * 100).toStringAsFixed(0)}% Match',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (isTopPick)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BEST',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCropName(String cropName) {
    // Convert crop name to title case (e.g., "chickpea" -> "Chickpea")
    return cropName
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String unit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: '0.0',
            suffixText: unit.isNotEmpty ? unit : null,
            suffixStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (double.tryParse(value) == null) {
              return 'Invalid';
            }
            return null;
          },
        ),
      ],
    );
  }
}
