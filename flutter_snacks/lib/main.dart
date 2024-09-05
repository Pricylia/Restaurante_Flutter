import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, int> _cartItems = {};

  static const List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Hambúrguer',
      'image': 'https://picsum.photos/150',
    },
    {
      'name': 'Pizza',
      'image': 'https://picsum.photos/150',
    },
    {
      'name': 'Sushi',
      'image': 'https://picsum.photos/150',
    },
    {
      'name': 'Salada',
      'image': 'https://picsum.photos/150',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(String itemName, int quantity) {
    setState(() {
      _cartItems[itemName] = (_cartItems[itemName] ?? 0) + quantity;
    });
  }

  void _removeFromCart(String itemName) {
    setState(() {
      _cartItems.remove(itemName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 0
            ? MenuScreen(
                menuItems: _menuItems,
                onAddToCart: _addToCart,
                cartItems: _cartItems,
              )
            : CartScreen(
                cartItems: _cartItems,
                onRemoveFromCart: _removeFromCart,
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Cardápio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico de Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  final Function(String, int) onAddToCart;
  final Map<String, int> cartItems;

  const MenuScreen(
      {super.key, required this.menuItems, required this.onAddToCart, required this.cartItems});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, int> _itemCounts = {};

  @override
  void initState() {
    super.initState();
    _itemCounts = {for (var item in widget.menuItems) item['name']: 0};
  }

  void _incrementCount(String itemName) {
    setState(() {
      _itemCounts[itemName] = _itemCounts[itemName]! + 1;
    });
  }

  void _decrementCount(String itemName) {
    setState(() {
      if (_itemCounts[itemName]! > 0) {
        _itemCounts[itemName] = _itemCounts[itemName]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.menuItems.length,
          itemBuilder: (context, index) {
            final item = widget.menuItems[index];
            final itemName = item['name'];
            final itemCount = _itemCounts[itemName]!;
            return Card(
              child: ListTile(
                leading: Image.network(item['image']),
                title: Text(itemName),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _decrementCount(itemName),
                    ),
                    Text(itemCount.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _incrementCount(itemName),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (_itemCounts.values.any((count) => count > 0)) // Exibe o botão se houver algum item selecionado
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.menuItems.forEach((item) {
                    final itemName = item['name'];
                    final itemCount = _itemCounts[itemName]!;
                    if (itemCount > 0) {
                      widget.onAddToCart(itemName, itemCount);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Itens adicionados ao carrinho!')),
                  );
                },
                child: const Text('Adicionar ao Carrinho'),
              ),
            ),
          ),
      ],
    );
  }
}

class CartScreen extends StatelessWidget {
  final Map<String, int> cartItems;
  final Function(String) onRemoveFromCart;

  const CartScreen({super.key, required this.cartItems, required this.onRemoveFromCart});

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(child: Text('Carrinho está vazio'));
    }
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final itemName = cartItems.keys.elementAt(index);
        final itemCount = cartItems[itemName]!;
        return Card(
          child: ListTile(
            title: Text('$itemName x$itemCount'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () => onRemoveFromCart(itemName),
            ),
          ),
        );
      },
    );
  }
}
