import 'package:flutter/material.dart';
import 'package:iron_ecommerce_app/models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/responsive_widgets.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      onTap: onTap,
      elevation: AppTheme.elevationMedium,
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.borderRadiusMedium),
              topRight: Radius.circular(AppTheme.borderRadiusMedium),
            ),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: CustomImageView(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Product details
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppTheme.paddingSmall),
                
                // Product specifications
                Text(
                  'Grade: ${product.grade} | Material: ${product.material}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    // ignore: deprecated_member_use
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppTheme.paddingMedium),
                
                // Price and action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)} / ${product.unit}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    
                    // View button
                    CustomButton(
                      text: 'View',
                      onPressed: onTap,
                      height: 36,
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      onTap: onTap,
      elevation: AppTheme.elevationSmall,
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusCircular),
            ),
            child: Icon(
              icon,
              size: 30,
              color: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: AppTheme.paddingMedium),
          
          // Category name
          Text(
            category,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      onTap: onTap,
      elevation: AppTheme.elevationSmall,
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Row(
        children: [
          // Feature icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusCircular),
            ),
            child: Icon(
              icon,
              size: 24,
              color: theme.colorScheme.secondary,
            ),
          ),
          
          const SizedBox(width: AppTheme.paddingLarge),
          
          // Feature details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feature title
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppTheme.paddingSmall),
                
                // Feature description
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Arrow icon
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class PromotionBanner extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const PromotionBanner({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: ResponsiveLayout(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner content
            _buildContent(context),
            
            const SizedBox(height: AppTheme.paddingLarge),
            
            // Banner button
            CustomButton(
              text: buttonText,
              onPressed: onButtonPressed,
              backgroundColor: Colors.white,
              textColor: theme.colorScheme.primary,
              width: double.infinity,
            ),
          ],
        ),
        tablet: Row(
          children: [
            // Banner content
            Expanded(
              flex: 3,
              child: _buildContent(context),
            ),
            
            const SizedBox(width: AppTheme.paddingLarge),
            
            // Banner button
            Expanded(
              flex: 1,
              child: CustomButton(
                text: buttonText,
                onPressed: onButtonPressed,
                backgroundColor: Colors.white,
                textColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner title
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
        
        const SizedBox(height: AppTheme.paddingSmall),
        
        // Banner description
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: (textColor ?? Colors.white).withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class ProductSpecificationCard extends StatelessWidget {
  final String title;
  final Map<String, String> specifications;

  const ProductSpecificationCard({
    super.key,
    required this.title,
    required this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      elevation: AppTheme.elevationSmall,
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppTheme.paddingMedium),
          
          const CustomDivider(height: 1),
          
          const SizedBox(height: AppTheme.paddingMedium),
          
          // Specifications
          ...specifications.entries.map((entry) => _buildSpecificationRow(
            context,
            entry.key,
            entry.value,
          )),
        ],
      ),
    );
  }
  
  Widget _buildSpecificationRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specification label
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          
          // Specification value
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final double quantity;
  final Function(double) onChanged;
  final double min;
  final double max;
  final double step;
  final String unit;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 1000,
    this.step = 1,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Decrease button
        _buildButton(
          context,
          Icons.remove,
          () {
            if (quantity > min) {
              onChanged(quantity - step);
            }
          },
        ),
        
        // Quantity display
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMedium,
              vertical: AppTheme.paddingSmall,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
            ),
            child: Text(
              '${quantity.toStringAsFixed(step.toString().split('.').last.length)} $unit',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        // Increase button
        _buildButton(
          context,
          Icons.add,
          () {
            if (quantity < max) {
              onChanged(quantity + step);
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          color: theme.colorScheme.surface,
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
