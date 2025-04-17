import 'package:flutter/material.dart';

class WeldingCompatibilityChart extends StatelessWidget {
  const WeldingCompatibilityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welding Compatibility Chart',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Introduction text
        const Text(
          'This chart helps you determine the compatibility between different steel grades and appropriate welding methods. '
          'Proper welding technique selection is crucial for structural integrity and performance.',
          style: TextStyle(fontSize: 14),
        ),
        
        const SizedBox(height: 24),
        
        // Steel grade selector
        _buildSteelGradeSelector(context),
        
        const SizedBox(height: 32),
        
        // Welding methods comparison table
        _buildWeldingMethodsTable(context),
        
        const SizedBox(height: 24),
        
        // Technical support section
        _buildTechnicalSupportSection(context),
      ],
    );
  }

  Widget _buildSteelGradeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Steel Grade:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        
        // Steel grade chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSteelGradeChip(context, 'A36', true),
            _buildSteelGradeChip(context, 'A572 Grade 50', false),
            _buildSteelGradeChip(context, 'A992', false),
            _buildSteelGradeChip(context, 'A53', false),
            _buildSteelGradeChip(context, 'A500', false),
            _buildSteelGradeChip(context, 'A615', false),
          ],
        ),
      ],
    );
  }

  Widget _buildSteelGradeChip(BuildContext context, String grade, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      label: Text(grade),
      onSelected: (selected) {
        // In a real app, this would update the selected grade
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildWeldingMethodsTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columns: const [
          DataColumn(label: Text('Welding Method')),
          DataColumn(label: Text('Compatibility\nwith A36')),
          DataColumn(label: Text('Preparation\nRequired')),
          DataColumn(label: Text('Skill Level')),
          DataColumn(label: Text('Best For')),
        ],
        rows: [
          _buildWeldingMethodRow(
            'Shielded Metal Arc\n(Stick Welding)',
            'Excellent',
            'Minimal',
            'Moderate',
            'Field work, repairs, general construction',
          ),
          _buildWeldingMethodRow(
            'Gas Metal Arc\n(MIG Welding)',
            'Excellent',
            'Clean surface',
            'Low to Moderate',
            'Production, thin materials, all positions',
          ),
          _buildWeldingMethodRow(
            'Flux Cored Arc',
            'Excellent',
            'Minimal',
            'Moderate',
            'Outdoor work, thick sections, high deposition',
          ),
          _buildWeldingMethodRow(
            'Gas Tungsten Arc\n(TIG Welding)',
            'Good',
            'Thorough cleaning',
            'High',
            'Precision work, thin materials, visible welds',
          ),
          _buildWeldingMethodRow(
            'Submerged Arc',
            'Excellent',
            'Joint preparation',
            'Moderate',
            'Heavy fabrication, long straight welds',
          ),
        ],
      ),
    );
  }

  DataRow _buildWeldingMethodRow(
    String method,
    String compatibility,
    String preparation,
    String skillLevel,
    String bestFor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(method, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(compatibility)),
        DataCell(Text(preparation)),
        DataCell(Text(skillLevel)),
        DataCell(Text(bestFor)),
      ],
    );
  }

  Widget _buildTechnicalSupportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Technical Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Need help with welding specifications or have questions about compatibility? '
            'Our technical team is available to provide expert guidance for your specific application.',
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // In a real app, this would navigate to a contact form
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Technical Support Request'),
                  content: const Text(
                    'In the full application, this would open a form to request technical support '
                    'for welding specifications and compatibility questions.',
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
            child: const Text('CONTACT TECHNICAL SUPPORT'),
          ),
        ],
      ),
    );
  }
}
