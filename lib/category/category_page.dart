import 'package:flutter/material.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final List<String> _categories = [
    'Groceries',
    'Rent',
    'Salary',
    'Entertainment',
  ];
  final TextEditingController _categoryController = TextEditingController();
  String? _editingCategory;

  // Add a new category
  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _categories.add(_categoryController.text);
        _categoryController.clear();
      });
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  // Edit an existing category
  void _editCategory(String oldCategory) {
    _categoryController.text = oldCategory;
    _editingCategory = oldCategory;
    _showAddEditDialog(context, isEditing: true);
  }

  // Save edited category
  void _saveEditedCategory() {
    if (_categoryController.text.isNotEmpty && _editingCategory != null) {
      setState(() {
        final index = _categories.indexOf(_editingCategory!);
        if (index != -1) {
          _categories[index] = _categoryController.text;
        }
        _editingCategory = null;
        _categoryController.clear();
      });
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  // Delete a category
  void _deleteCategory(String category) {
    setState(() {
      _categories.remove(category);
    });
  }

  // Show dialog for adding or editing a category
  void _showAddEditDialog(BuildContext context, {bool isEditing = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isEditing ? _saveEditedCategory : _addCategory,
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Categories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _categories.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories yet. Add one to get started!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editCategory(category),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteCategory(category),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _showAddEditDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add New Category',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
