import 'package:flutter/material.dart';

class TechnicalSpecsWidget extends StatelessWidget {
  final Map<String, dynamic> dimensions;
  final String material;
  final String grade;
  final String finish;
  final double weightPerUnit;
  final List<String> certifications;

  const TechnicalSpecsWidget({
    super.key,
    required this.dimensions,
    required this.material,
    required this.grade,
    required this.finish,
    required this.weightPerUnit,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpecificationSection('Material Properties', [
          _buildSpecRow('Material', material),
          _buildSpecRow('Grade', grade),
          _buildSpecRow('Finish', finish),
          _buildSpecRow('Weight per Unit', '$weightPerUnit tons'),
        ]),
        
        const SizedBox(height: 16),
        
        _buildSpecificationSection('Dimensions', [
          if (dimensions.containsKey('length'))
            _buildSpecRow('Length', '${dimensions['length']} feet'),
          if (dimensions.containsKey('width'))
            _buildSpecRow('Width', '${dimensions['width']} inches'),
          if (dimensions.containsKey('height'))
            _buildSpecRow('Height', '${dimensions['height']} inches'),
          if (dimensions.containsKey('thickness'))
            _buildSpecRow('Thickness', '${dimensions['thickness']} inches'),
          if (dimensions.containsKey('diameter'))
            _buildSpecRow('Diameter', '${dimensions['diameter']} inches'),
          if (dimensions.containsKey('wall_thickness'))
            _buildSpecRow('Wall Thickness', '${dimensions['wall_thickness']} inches'),
        ]),
        
        const SizedBox(height: 16),
        
        _buildSpecificationSection('Certifications', [
          for (final certification in certifications)
            _buildSpecRow('', certification, hasLabel: false),
        ]),
        
        const SizedBox(height: 16),
        
        _buildSpecificationSection('Applications', [
          _buildSpecRow('', 'Construction', hasLabel: false),
          _buildSpecRow('', 'Infrastructure', hasLabel: false),
          _buildSpecRow('', 'Manufacturing', hasLabel: false),
          _buildSpecRow('', 'Transportation', hasLabel: false),
        ]),
      ],
    );
  }

  Widget _buildSpecificationSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, {bool hasLabel = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: hasLabel
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Text(value),
                ),
              ],
            )
          : Row(
              children: [
                const Icon(Icons.check, size: 16),
                const SizedBox(width: 8),
                Text(value),
              ],
            ),
    );
  }
}
