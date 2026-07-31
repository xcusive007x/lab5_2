import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Master-Detail',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MasterDetailScreen(),
    );
  }
}

class MasterDetailScreen extends StatefulWidget {
  const MasterDetailScreen({super.key});

  @override
  State<MasterDetailScreen> createState() => _MasterDetailScreenState();
}

class _MasterDetailScreenState extends State<MasterDetailScreen> {
  final List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = items.first;
  }

  void _onItemSelect(String item, bool isWide) {
    setState(() {
      selectedItem = item;
    });
    if (!isWide) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(item: item),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive LayoutBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 700;

          if (wide) {
            return Row(
              children: [
                SizedBox(
                  width: 280,
                  child: ItemList(
                    items: items,
                    selectedItem: selectedItem,
                    onTap: (item) => _onItemSelect(item, wide),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: DetailPane(item: selectedItem),
                ),
              ],
            );
          }
          return ItemList(
            items: items,
            selectedItem: selectedItem,
            onTap: (item) => _onItemSelect(item, wide),
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onTap;

  const ItemList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedItem;

        return ListTile(
          title: Text(item),
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () => onTap(item),
        );
      },
    );
  }
}

class DetailPane extends StatelessWidget {
  final String? item;

  const DetailPane({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(child: Text('กรุณาเลือกรายการ'));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 64, color: Colors.deepPurple),
          const SizedBox(height: 16),
          Text(
            'รายละเอียดของ $item',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'นี่คือเนื้อหารายละเอียดของ $item',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
class DetailPage extends StatelessWidget {
  final String item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item),
      ),
      body: DetailPane(item: item),
    );
  }
}
