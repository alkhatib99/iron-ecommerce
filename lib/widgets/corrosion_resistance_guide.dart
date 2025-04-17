import 'package:flutter/material.dart';

class CorrosionResistanceGuide extends StatelessWidget {
  const CorrosionResistanceGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Corrosion Resistance Guide',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Introduction text
        const Text(
          'Selecting the right finish for your iron products is crucial for ensuring longevity and performance in different environments. '
          'Use this guide to determine the most appropriate finish based on your application and environmental conditions.',
          style: TextStyle(fontSize: 14),
        ),
        
        const SizedBox(height: 24),
        
        // Environment selector
        _buildEnvironmentSelector(context),
        
        const SizedBox(height: 32),
        
        // Finish comparison table
        _buildFinishComparisonTable(context),
        
        const SizedBox(height: 24),
        
        // Additional information
        const Text(
          'Note: The above recommendations are general guidelines. For specific applications or extreme environments, '
          'please consult with our technical team for customized recommendations.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildEnvironmentSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Environment:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        
        // Environment cards
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildEnvironmentCard(
              context,
              'Indoor',
              Icons.home,
              'Low humidity, temperature-controlled spaces',
              Colors.blue.shade50,
              Colors.blue,
            ),
            _buildEnvironmentCard(
              context,
              'Outdoor',
              Icons.landscape,
              'Regular exposure to weather and moisture',
              Colors.green.shade50,
              Colors.green,
            ),
            _buildEnvironmentCard(
              context,
              'Coastal',
              Icons.waves,
              'High salt content in air, proximity to ocean',
              Colors.cyan.shade50,
              Colors.cyan,
            ),
            _buildEnvironmentCard(
              context,
              'Industrial',
              Icons.factory,
              'Exposure to chemicals, pollutants, or abrasives',
              Colors.orange.shade50,
              Colors.orange,
            ),
            _buildEnvironmentCard(
              context,
              'Underground',
              Icons.layers,
              'Direct soil contact, high moisture',
              Colors.brown.shade50,
              Colors.brown,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnvironmentCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    Color backgroundColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: () {
        // In a real app, this would filter the recommendations
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('$title Environment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recommended finishes for $title environments:'),
                const SizedBox(height: 12),
                _buildRecommendationsForEnvironment(title),
              ],
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
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: iconColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsForEnvironment(String environment) {
    // Return recommendations based on environment
    switch (environment) {
      case 'Indoor':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Raw/Unfinished - Suitable for dry indoor areas'),
            Text('• Painted - Good for general indoor use'),
            Text('• Powder Coated - Excellent for decorative applications'),
          ],
        );
      case 'Outdoor':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Hot-Dip Galvanized - Excellent for outdoor exposure'),
            Text('• Powder Coated - Good with proper maintenance'),
            Text('• Zinc-Aluminum Coated - Very good corrosion resistance'),
          ],
        );
      case 'Coastal':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Hot-Dip Galvanized - Recommended minimum'),
            Text('• Duplex System (Galvanized + Painted) - Excellent protection'),
            Text('• Stainless Steel - Best for severe coastal environments'),
          ],
        );
      case 'Industrial':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Epoxy Coated - Good chemical resistance'),
            Text('• Hot-Dip Galvanized - Good for most industrial settings'),
            Text('• Specialized Coatings - Based on specific chemicals present'),
          ],
        );
      case 'Underground':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Hot-Dip Galvanized - Minimum recommendation'),
            Text('• Coal Tar Epoxy - Excellent for buried applications'),
            Text('• Cathodic Protection - Recommended for critical applications'),
          ],
        );
      default:
        return const Text('No specific recommendations available.');
    }
  }

  Widget _buildFinishComparisonTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columns: const [
          DataColumn(label: Text('Finish Type')),
          DataColumn(label: Text('Corrosion\nResistance')),
          DataColumn(label: Text('Lifespan')),
          DataColumn(label: Text('Cost')),
          DataColumn(label: Text('Best For')),
        ],
        rows: [
          _buildFinishRow(
            'Raw/Unfinished',
            'Poor',
            '1-2 years',
            '\$',
            'Indoor, dry environments',
          ),
          _buildFinishRow(
            'Painted',
            'Fair',
            '2-5 years',
            '\$',
            'Indoor, light outdoor use',
          ),
          _buildFinishRow(
            'Powder Coated',
            'Good',
            '5-10 years',
            '\$\$',
            'Decorative, moderate exposure',
          ),
          _buildFinishRow(
            'Hot-Dip Galvanized',
            'Excellent',
            '20-50 years',
            '\$\$',
            'Outdoor, industrial, underground',
          ),
          _buildFinishRow(
            'Zinc-Aluminum Coated',
            'Very Good',
            '15-30 years',
            '\$\$',
            'Outdoor, moderate coastal',
          ),
          _buildFinishRow(
            'Duplex System',
            'Superior',
            '30-60 years',
            '\$\$\$',
            'Coastal, industrial, critical applications',
          ),
          _buildFinishRow(
            'Stainless Steel',
            'Superior',
            '50+ years',
            '\$\$\$\$',
            'Coastal, food grade, architectural',
          ),
        ],
      ),
    );
  }

  DataRow _buildFinishRow(
    String finish,
    String resistance,
    String lifespan,
    String cost,
    String bestFor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(finish, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(resistance)),
        DataCell(Text(lifespan)),
        DataCell(Text(cost)),
        DataCell(Text(bestFor)),
      ],
    );
  }
}
