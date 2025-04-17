import 'package:flutter/material.dart';

class CertificationsWidget extends StatelessWidget {
  final List<String> certifications;

  const CertificationsWidget({
    super.key,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality Certifications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Certification cards
        ...certifications.map((certification) => _buildCertificationCard(context, certification)),
        
        // Additional certifications info
        const SizedBox(height: 24),
        const Text(
          'All our products meet or exceed industry standards and come with proper documentation. '
          'Certificates can be downloaded from the Documents tab or requested during checkout.',
          style: TextStyle(fontSize: 14),
        ),
        
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // In a real app, this would show a dialog with more information
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Certification Information'),
                content: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Our certifications ensure that all products meet rigorous quality and safety standards. '
                        'Each certification covers specific aspects of the manufacturing process, material properties, '
                        'and performance characteristics.',
                      ),
                      SizedBox(height: 16),
                      Text(
                        'For custom certification requirements, please contact our technical support team.',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CLOSE'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.info_outline),
          label: const Text('LEARN MORE ABOUT CERTIFICATIONS'),
        ),
      ],
    );
  }

  Widget _buildCertificationCard(BuildContext context, String certification) {
    // Get certification details based on name
    final details = _getCertificationDetails(certification);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Certification icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                details.icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            
            // Certification details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certification,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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

  _CertificationDetails _getCertificationDetails(String certification) {
    // Return details based on certification name
    switch (certification) {
      case 'ASTM A36':
        return _CertificationDetails(
          Icons.verified,
          'Standard specification for carbon structural steel with minimum yield strength of 36,000 psi.',
        );
      case 'ASTM A53':
        return _CertificationDetails(
          Icons.verified,
          'Standard specification for pipe, steel, black and hot-dipped, zinc-coated, welded and seamless.',
        );
      case 'ASTM A615':
        return _CertificationDetails(
          Icons.verified,
          'Standard specification for deformed and plain carbon-steel bars for concrete reinforcement.',
        );
      case 'ISO 9001':
        return _CertificationDetails(
          Icons.workspace_premium,
          'International standard for quality management systems to ensure consistent quality and customer satisfaction.',
        );
      default:
        return _CertificationDetails(
          Icons.check_circle,
          'Industry standard certification ensuring product quality and performance.',
        );
    }
  }
}

class _CertificationDetails {
  final IconData icon;
  final String description;

  _CertificationDetails(this.icon, this.description);
}
