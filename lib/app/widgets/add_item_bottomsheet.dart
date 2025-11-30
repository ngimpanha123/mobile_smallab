import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

class AddItemBottomsheet extends StatefulWidget {
  const AddItemBottomsheet({super.key});

  @override
  State<AddItemBottomsheet> createState() => _AddItemBottomsheetState();
}

class _AddItemBottomsheetState extends State<AddItemBottomsheet> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedBrand;

  List<String> categories = ["Electronics", "Clothes", "Food", "Other"];
  List<String> brands = ["Samsung", "Apple", "Nike", "Adidas"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet Handle
            Center(
              child: Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "Add New Item",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: productNameController,
              label: "Product Name",
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              value: selectedCategory,
              label: "Category",
              icon: Icons.category_outlined,
              items: categories,
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              value: selectedBrand,
              label: "Brand",
              icon: Icons.branding_watermark_outlined,
              items: brands,
              onChanged: (value) => setState(() => selectedBrand = value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: priceController,
              label: "Price",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descriptionController,
              label: "Description",
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                onPressed: () {

                },
              ),
            ),
            SizedBox(height: AppSpacing.paddingXL),
          ],
        ),
      ),
    );
  }

  // Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Reusable Dropdown
  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}