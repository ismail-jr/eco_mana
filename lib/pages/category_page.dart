import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Box<Category> categoryBox;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryBox = Hive.box<Category>('categories');
  }

  void _addCategory() {
    if (_controller.text.isEmpty) return;

    final category = Category(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // or use any unique id logic
      name: _controller.text,
    );
    categoryBox.add(category);
    _controller.clear();
  }

  void _deleteCategory(int index) {
    categoryBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "New Category",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: categoryBox.listenable(),
              builder: (context, Box<Category> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text("No categories yet."));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final category = box.getAt(index);
                    if (category == null) return const SizedBox.shrink();

                    return ListTile(
                      title: Text(category.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCategory(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
