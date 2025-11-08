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
    final summary = _result!.summary;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Main Result Card
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green.shade600,
                ),
                const SizedBox(height: 16),
                Text(
                  recommendedCrops[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selectedCrop.status == 'suitable'
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(selectedCrop.chance * 100).toStringAsFixed(0)}% Confidence',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selectedCrop.status == 'suitable'
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Text(
                //   selectedCrop.summary,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.grey.shade600,
                //     height: 1.5,
                //   ),
                // ),
              ],
            ),
          ),

          // Other Recommendations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Other Suitable Crops',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                ...recommendedCrops.skip(1).map((crop) => _buildCropTile(crop)),
                const SizedBox(height: 20),

                // Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Try Again Button
                OutlinedButton(
                  onPressed: () => setState(() => _result = null),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text(
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
          ),
        ],
      ),
    );
  }

  Widget _buildCropTile(String crop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            crop.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
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
