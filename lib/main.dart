import 'package:flutter/material.dart';

void main() {
  runApp(const EasyBorrowApp());
}

class EasyBorrowApp extends StatelessWidget {
  const EasyBorrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyBorrow San Ramon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0056B3),
          primary: const Color(0xFF0056B3),
          error: const Color(0xFFD9534F),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0056B3),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// Data Models

class Equipment {
  final String id;
  final String name;
  final IconData icon;
  int quantityAvailable;

  Equipment({
    required this.id,
    required this.name,
    required this.icon,
    required this.quantityAvailable,
  });
}

class BorrowRequest {
  final String id;
  final Equipment equipment;
  final int quantity;
  final String purpose;
  final DateTime returnDate;
  String status; // 'Borrowed', 'Returned'

  BorrowRequest({
    required this.id,
    required this.equipment,
    required this.quantity,
    required this.purpose,
    required this.returnDate,
    this.status = 'Borrowed',
  });
}

// Global State (Simple)
class AppState {
  static final List<Equipment> inventory = [
    Equipment(id: '1', name: 'Chairs', icon: Icons.chair, quantityAvailable: 50),
    Equipment(id: '2', name: 'Tables', icon: Icons.table_restaurant, quantityAvailable: 20),
    Equipment(id: '3', name: 'Tents', icon: Icons.holiday_village, quantityAvailable: 5),
    Equipment(id: '4', name: 'Sound System', icon: Icons.speaker, quantityAvailable: 2),
    Equipment(id: '5', name: 'Sports Equipment', icon: Icons.sports_basketball, quantityAvailable: 10),
  ];

  static final List<BorrowRequest> myRequests = [];
}

// Auth Wrapper
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool isLoginScreen = true;

  void toggleScreen() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      isLoginScreen = true;
    });
  }

  void registerSuccess() {
    setState(() {
      isLoginScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return MainDashboard(onLogout: logout);
    } else {
      if (isLoginScreen) {
        return LoginScreen(onLogin: login, onToggle: toggleScreen);
      } else {
        return RegisterScreen(onRegister: registerSuccess, onToggle: toggleScreen);
      }
    }
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onToggle;

  const LoginScreen({super.key, required this.onLogin, required this.onToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.handshake, size: 64, color: Color(0xFF0056B3)),
                      const SizedBox(height: 16),
                      const Text(
                        'EasyBorrow San Ramon',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0056B3),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onLogin();
                            }
                          },
                          child: const Text('Login', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: widget.onToggle,
                        child: const Text('Create an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Register Screen
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onToggle;

  const RegisterScreen({super.key, required this.onRegister, required this.onToggle});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Register',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Address',
                            hintText: '(Purok/Street)',
                            border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Contact', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0056B3),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onRegister();
                            }
                          },
                          child: const Text('Register', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: widget.onToggle,
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Main Dashboard
class MainDashboard extends StatefulWidget {
  final VoidCallback onLogout;

  const MainDashboard({super.key, required this.onLogout});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      EquipmentListScreen(onStateUpdate: () => setState(() {})),
      MyRequestsScreen(onStateUpdate: () => setState(() {})),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyBorrow San Ramon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            color: const Color(0xFFD9534F),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0056B3),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Requests',
          ),
        ],
      ),
    );
  }
}

// Equipment List Screen
class EquipmentListScreen extends StatelessWidget {
  final VoidCallback onStateUpdate;

  const EquipmentListScreen({super.key, required this.onStateUpdate});

  void _showBorrowDialog(BuildContext context, Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => BorrowDialog(equipment: equipment),
    ).then((result) {
      if (result == true) {
        onStateUpdate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Welcome to EasyBorrow San Ramon!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: AppState.inventory.length,
            itemBuilder: (context, index) {
              final item = AppState.inventory[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 64, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available: ${item.quantityAvailable}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0056B3),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: item.quantityAvailable > 0
                              ? () => _showBorrowDialog(context, item)
                              : null,
                          child: const Text('Borrow'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Borrow Dialog
class BorrowDialog extends StatefulWidget {
  final Equipment equipment;

  const BorrowDialog({super.key, required this.equipment});

  @override
  State<BorrowDialog> createState() => _BorrowDialogState();
}

class _BorrowDialogState extends State<BorrowDialog> {
  final _formKey = GlobalKey<FormState>();
  int _quantity = 1;
  String _purpose = '';
  DateTime? _returnDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Borrow ${widget.equipment.name}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) return 'Invalid quantity';
                  if (qty > widget.equipment.quantityAvailable) {
                    return 'Only ${widget.equipment.quantityAvailable} available';
                  }
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Purpose', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _purpose = value!,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_returnDate == null
                    ? 'Select Return Date'
                    : 'Return Date: ${_returnDate!.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                tileColor: Colors.transparent,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _returnDate = date;
                    });
                  }
                },
              ),
              if (_returnDate == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select a return date',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0056B3),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate() && _returnDate != null) {
              _formKey.currentState!.save();
              
              // Process Borrow
              setState(() {
                widget.equipment.quantityAvailable -= _quantity;
                AppState.myRequests.add(
                  BorrowRequest(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    equipment: widget.equipment,
                    quantity: _quantity,
                    purpose: _purpose,
                    returnDate: _returnDate!,
                  ),
                );
              });
              
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Equipment borrowed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

// My Requests Screen
class MyRequestsScreen extends StatelessWidget {
  final VoidCallback onStateUpdate;

  const MyRequestsScreen({super.key, required this.onStateUpdate});

  void _returnItem(BuildContext context, BorrowRequest request) {
    request.status = 'Returned';
    request.equipment.quantityAvailable += request.quantity;
    onStateUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipment returned successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (AppState.myRequests.isEmpty) {
      return const Center(
        child: Text('You have no borrow requests.', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: AppState.myRequests.length,
      itemBuilder: (context, index) {
        final request = AppState.myRequests[index];
        final isBorrowed = request.status == 'Borrowed';

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(request.equipment.icon, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.equipment.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Quantity: ${request.quantity}'),
                      Text('Purpose: ${request.purpose}'),
                      Text('Return Date: ${request.returnDate.toLocal().toString().split(' ')[0]}'),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${request.status}',
                        style: TextStyle(
                          color: isBorrowed ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isBorrowed)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD9534F),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _returnItem(context, request),
                    child: const Text('Return'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
