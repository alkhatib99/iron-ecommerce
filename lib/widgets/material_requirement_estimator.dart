import 'package:flutter/material.dart';

class MaterialRequirementEstimator extends StatefulWidget {
  const MaterialRequirementEstimator({super.key});

  @override
  State<MaterialRequirementEstimator> createState() => _MaterialRequirementEstimatorState();
}

class _MaterialRequirementEstimatorState extends State<MaterialRequirementEstimator> {
  final _formKey = GlobalKey<FormState>();
  
  // Project type selection
  String _selectedProjectType = 'Building Frame';
  final List<String> _projectTypes = [
    'Building Frame', 
    'Bridge', 
    'Warehouse', 
    'Residential Construction',
    'Commercial Building'
  ];
  
  // Project dimensions
  final _lengthController = TextEditingController(text: '100');
  final _widthController = TextEditingController(text: '50');
  final _heightController = TextEditingController(text: '30');
  final _floorsController = TextEditingController(text: '2');
  
  // Results
  bool _hasCalculated = false;
  Map<String, double> _estimatedMaterials = {};
  double _totalWeight = 0;
  double _totalCost = 0;
  
  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _floorsController.dispose();
    super.dispose();
  }

  void _calculateRequirements() {
    if (_formKey.currentState!.validate()) {
      // Get dimensions
      final double length = double.parse(_lengthController.text);
      final double width = double.parse(_widthController.text);
      final double height = double.parse(_heightController.text);
      final int floors = int.parse(_floorsController.text);
      
      // Reset results
      _estimatedMaterials = {};
      _totalWeight = 0;
      _totalCost = 0;
      
      // Calculate based on project type
      switch (_selectedProjectType) {
        case 'Building Frame':
          _calculateBuildingFrame(length, width, height, floors);
          break;
        case 'Bridge':
          _calculateBridge(length, width, height);
          break;
        case 'Warehouse':
          _calculateWarehouse(length, width, height);
          break;
        case 'Residential Construction':
          _calculateResidential(length, width, height, floors);
          break;
        case 'Commercial Building':
          _calculateCommercial(length, width, height, floors);
          break;
      }
      
      setState(() {
        _hasCalculated = true;
      });
    }
  }
  
  void _calculateBuildingFrame(double length, double width, double height, int floors) {
    // Simple estimation formulas for demonstration
    // In a real app, these would be much more sophisticated
    
    // Structural steel (I-beams, columns)
    final double structuralSteel = length * width * height * 0.05 * floors;
    _estimatedMaterials['Structural I-Beams'] = structuralSteel;
    
    // Reinforcement bars
    final double rebar = length * width * 0.01 * floors;
    _estimatedMaterials['Reinforcement Bars'] = rebar;
    
    // Steel sheets for flooring
    final double steelSheets = length * width * 0.008 * floors;
    _estimatedMaterials['Steel Sheets'] = steelSheets;
    
    // Steel pipes for utilities
    final double steelPipes = (length + width) * 0.02 * floors;
    _estimatedMaterials['Steel Pipes'] = steelPipes;
    
    // Calculate totals
    _calculateTotals();
  }
  
  void _calculateBridge(double length, double width, double height) {
    // Bridge-specific calculations
    
    // Main support beams
    final double mainBeams = length * width * 0.08;
    _estimatedMaterials['Heavy I-Beams'] = mainBeams;
    
    // Reinforcement bars
    final double rebar = length * width * 0.03;
    _estimatedMaterials['Reinforcement Bars'] = rebar;
    
    // Steel cables
    final double cables = length * 0.05;
    _estimatedMaterials['Steel Cables'] = cables;
    
    // Steel plates
    final double plates = length * width * 0.01;
    _estimatedMaterials['Steel Plates'] = plates;
    
    // Calculate totals
    _calculateTotals();
  }
  
  void _calculateWarehouse(double length, double width, double height) {
    // Warehouse-specific calculations
    
    // Structural columns
    final double columns = (length + width) * 0.04;
    _estimatedMaterials['Steel Columns'] = columns;
    
    // Roof trusses
    final double trusses = length * width * 0.03;
    _estimatedMaterials['Steel Trusses'] = trusses;
    
    // Wall panels
    final double panels = (length + width) * 2 * height * 0.01;
    _estimatedMaterials['Steel Panels'] = panels;
    
    // Purlins and girts
    final double purlins = length * width * 0.015;
    _estimatedMaterials['Purlins and Girts'] = purlins;
    
    // Calculate totals
    _calculateTotals();
  }
  
  void _calculateResidential(double length, double width, double height, int floors) {
    // Residential-specific calculations
    
    // Steel framing
    final double framing = length * width * 0.02 * floors;
    _estimatedMaterials['Steel Framing'] = framing;
    
    // Reinforcement bars
    final double rebar = length * width * 0.008 * floors;
    _estimatedMaterials['Reinforcement Bars'] = rebar;
    
    // Steel roofing
    final double roofing = length * width * 0.005;
    _estimatedMaterials['Steel Roofing'] = roofing;
    
    // Calculate totals
    _calculateTotals();
  }
  
  void _calculateCommercial(double length, double width, double height, int floors) {
    // Commercial building-specific calculations
    
    // Structural steel
    final double structuralSteel = length * width * height * 0.06 * floors;
    _estimatedMaterials['Structural Steel'] = structuralSteel;
    
    // Reinforcement bars
    final double rebar = length * width * 0.015 * floors;
    _estimatedMaterials['Reinforcement Bars'] = rebar;
    
    // Steel decking
    final double decking = length * width * 0.01 * floors;
    _estimatedMaterials['Steel Decking'] = decking;
    
    // Facade support
    final double facade = (length + width) * 2 * height * 0.008;
    _estimatedMaterials['Facade Support'] = facade;
    
    // Calculate totals
    _calculateTotals();
  }
  
  void _calculateTotals() {
    // Calculate total weight
    _totalWeight = _estimatedMaterials.values.fold(0, (sum, weight) => sum + weight);
    
    // Calculate approximate cost (simplified)
    // In a real app, this would use actual product prices
    _totalCost = _totalWeight * 850; // Assuming average price of $850 per ton
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project type selector
            Text(
              'Project Type:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedProjectType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: _projectTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedProjectType = value;
                    _hasCalculated = false;
                  });
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Project dimensions
            Text(
              'Project Dimensions:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Length field
            _buildDimensionField('Length (feet)', _lengthController),
            
            // Width field
            _buildDimensionField('Width (feet)', _widthController),
            
            // Height field
            _buildDimensionField('Height (feet)', _heightController),
            
            // Floors field (only for building types)
            if (_selectedProjectType == 'Building Frame' || 
                _selectedProjectType == 'Residential Construction' || 
                _selectedProjectType == 'Commercial Building')
              _buildDimensionField('Number of Floors', _floorsController),
            
            const SizedBox(height: 24),
            
            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateRequirements,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('CALCULATE REQUIREMENTS', style: TextStyle(fontSize: 16)),
              ),
            ),
            
            // Results section
            if (_hasCalculated) ...[
              const SizedBox(height: 32),
              Text(
                'Estimated Material Requirements:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Materials list
              ..._estimatedMaterials.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        '${entry.value.toStringAsFixed(2)} tons',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const Divider(height: 32),
              
              // Total weight
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Weight:'),
                  Text(
                    '${_totalWeight.toStringAsFixed(2)} tons',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Estimated cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Cost:'),
                  Text(
                    '\$${_totalCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Request quote button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // In a real app, this would navigate to a quote request form
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quote request feature will be available soon'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('REQUEST DETAILED QUOTE', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildDimensionField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          if (double.parse(value) <= 0) {
            return 'Value must be greater than 0';
          }
          return null;
        },
      ),
    );
  }
}
