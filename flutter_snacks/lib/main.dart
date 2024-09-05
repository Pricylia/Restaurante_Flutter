import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
    );
  }
}

// Tela de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == 'teste@teste.com' && password == '123456') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos')),
      );
    }
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: navigateToRegister,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Cadastro
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  void register() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String contact = contactController.text;

    // Aqui você pode adicionar a lógica de registro, como salvar os dados do usuário.
    print('Nome: $name, E-mail: $email, Senha: $password, Contato: $contact');

    // Após o cadastro, redireciona de volta para a tela de Login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contato'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
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
  List<Map<String, dynamic>> _orderHistory = [];
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';
  String _userContact = '123456789';

  static const List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Hambúrguer',
      'image': 'https://picsum.photos/150',
      'price': 20.0,
    },
    {
      'name': 'Pizza',
      'image': 'https://picsum.photos/150',
      'price': 30.0,
    },
    {
      'name': 'Sushi',
      'image': 'https://picsum.photos/150',
      'price': 25.0,
    },
    {
      'name': 'Salada',
      'image': 'https://picsum.photos/150',
      'price': 15.0,
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

  void _finalizeOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryScreen(
          cartItems: _cartItems,
          menuItems: _menuItems,
          onFinalizePurchase: _finalizePurchase,
        ),
      ),
    );
  }

  void _finalizePurchase(String paymentMethod, double totalAmount) {
    setState(() {
      _orderHistory.add({
        'items': Map<String, int>.from(_cartItems),
        'total': totalAmount,
        'paymentMethod': paymentMethod,
        'date': DateTime.now(),
      });
      _cartItems.clear();
    });
    Navigator.pop(context); // Fecha a tela de resumo e volta ao carrinho
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compra finalizada!')),
    );
  }

  void _updateUser(String name, String email, String contact) {
    setState(() {
      _userName = name;
      _userEmail = email;
      _userContact = contact;
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
            : _selectedIndex == 1
                ? CartScreen(
                    cartItems: _cartItems,
                    onRemoveFromCart: _removeFromCart,
                    onFinalizeOrder: _finalizeOrder,
                    menuItems: _menuItems,
                  )
                : _selectedIndex == 2
                    ? HistoryScreen(orderHistory: _orderHistory)
                    : UserScreen(
                        userName: _userName,
                        userEmail: _userEmail,
                        userContact: _userContact,
                        onUpdateUser: _updateUser,
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
            final itemPrice = item['price'];
            final itemCount = _itemCounts[itemName]!;
            return Card(
              child: ListTile(
                leading: Image.network(item['image']),
                title: Text('$itemName - R\$${itemPrice.toStringAsFixed(2)}'),
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
        if (_itemCounts.values.any((count) => count > 0))
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
  final VoidCallback onFinalizeOrder;
  final List<Map<String, dynamic>> menuItems;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onFinalizeOrder,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    cartItems.forEach((itemName, itemCount) {
      final item = menuItems.firstWhere((menuItem) => menuItem['name'] == itemName);
      totalPrice += item['price'] * itemCount;
    });

    return Stack(
      children: [
        if (cartItems.isEmpty)
          const Center(child: Text('Carrinho está vazio'))
        else
          ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final itemName = cartItems.keys.elementAt(index);
              final itemCount = cartItems[itemName]!;
              final item = menuItems.firstWhere((menuItem) => menuItem['name'] == itemName);
              final itemPrice = item['price'];
              return Card(
                child: ListTile(
                  title: Text('$itemName x$itemCount'),
                  subtitle: Text('R\$${(itemPrice * itemCount).toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () => onRemoveFromCart(itemName),
                  ),
                ),
              );
            },
          ),
        if (cartItems.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: R\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onFinalizeOrder,
                  child: const Text('Finalizar Pedido'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class OrderSummaryScreen extends StatefulWidget {
  final Map<String, int> cartItems;
  final List<Map<String, dynamic>> menuItems;
  final Function(String, double) onFinalizePurchase;

  OrderSummaryScreen({
    super.key,
    required this.cartItems,
    required this.menuItems,
    required this.onFinalizePurchase,
  });

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String _selectedPaymentMethod = 'Cartão de Crédito';

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    widget.cartItems.forEach((itemName, itemCount) {
      final item = widget.menuItems.firstWhere((menuItem) => menuItem['name'] == itemName);
      totalPrice += item['price'] * itemCount;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Itens:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...widget.cartItems.entries.map((entry) {
              final itemName = entry.key;
              final itemCount = entry.value;
              final item = widget.menuItems.firstWhere((menuItem) => menuItem['name'] == itemName);
              return Text(
                  '$itemName x$itemCount - R\$${(item['price'] * itemCount).toStringAsFixed(2)}');
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Forma de Pagamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              items: <String>['Cartão de Crédito', 'Cartão de Débito', 'Dinheiro']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
            ),
            const Spacer(),
            Text(
              'Total: R\$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onFinalizePurchase(_selectedPaymentMethod, totalPrice);
              },
              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderHistory;

  const HistoryScreen({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return orderHistory.isEmpty
        ? const Center(child: Text('Nenhum pedido realizado'))
        : ListView.builder(
            itemCount: orderHistory.length,
            itemBuilder: (context, index) {
              final order = orderHistory[index];
              final items = order['items'] as Map<String, int>;
              final paymentMethod = order['paymentMethod'] as String;
              final total = order['total'] as double;
              final date = order['date'] as DateTime;

              // Formatar a data e a hora como dd/MM/yyyy HH:MM:SS
              final formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);

              return Card(
                child: ListTile(
                  title: Text('Pedido ${index + 1} - $formattedDateTime'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Itens: ${items.entries.map((e) => '${e.key} x${e.value}').join(', ')}'),
                      Text('Total: R\$${total.toStringAsFixed(2)}'),
                      Text('Pagamento: $paymentMethod'),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class UserScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userContact;
  final Function(String, String, String) onUpdateUser;

  const UserScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userContact,
    required this.onUpdateUser,
  });

  void navigateToEditUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(
          currentName: userName,
          currentEmail: userEmail,
          currentContact: userContact,
          onUpdateUser: onUpdateUser,
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: $userName', style: const TextStyle(fontSize: 18)),
          Text('E-mail: $userEmail', style: const TextStyle(fontSize: 18)),
          Text('Contato: $userContact', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateToEditUser(context),
            child: const Text('Alterar Dados'),
          ),
          ElevatedButton(
            onPressed: () => logout(context),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

// Tela de Alterar Dados
class EditUserScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentContact;
  final Function(String, String, String) onUpdateUser;

  const EditUserScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentContact,
    required this.onUpdateUser,
  });

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentName;
    emailController.text = widget.currentEmail;
    contactController.text = widget.currentContact;
  }

  void saveChanges() {
    String newName = nameController.text;
    String newEmail = emailController.text;
    String newContact = contactController.text;

    widget.onUpdateUser(newName, newEmail, newContact);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contato'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}