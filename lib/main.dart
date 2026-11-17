import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';

void main() {
  runApp(const HelpNearApp());
}

// HELPNEAR THEME (Bite-inspired: crimson, amber, white, soft grey fields)
// Constant names are kept the same so the rest of your code is untouched.
const Color primaryGreen = Color(0xFF9B0A0A); // deep crimson (primary)
const Color accentGreen = Color(0xFFC4161C); // brighter red (accent)
const Color lightGreen = Color(0xFFFBE9E7); // soft red tint
const Color backgroundColor = Color(0xFFFFFFFF);
const Color textColor = Color(0xFF2B2323);
const Color amber = Color(0xFFFFB81C); // warm yellow accent
const Color fieldGrey = Color(0xFFF3F1F1); // input background
const Color borderSoft = Color(0xFFEDE6E6); // card borders

// REQUEST MODEL
class HelpRequest {
  final String id;
  final String title;
  final String category;
  final String description;
  final String location;
  final String requester;
  String status;
  String? volunteer;

  HelpRequest({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    required this.requester,
    this.status = 'Pending',
    this.volunteer,
  });
}

// MAIN APP
class HelpNearApp extends StatelessWidget {
  const HelpNearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpNear',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.ralewayTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: accentGreen,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: primaryGreen,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.raleway(
            color: primaryGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
            textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: primaryGreen),
            textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryGreen,
          contentTextStyle: GoogleFonts.raleway(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fieldGrey,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: primaryGreen, width: 1.5),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// REUSABLE SECTION TITLE
Widget sectionTitle(String title, {String? subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    ],
  );
}

// REUSABLE STATUS BADGE
Widget statusBadge(String status) {
  Color color;
  Color background;

  switch (status) {
    case 'Accepted':
      color = Colors.blue.shade800;
      background = Colors.blue.shade50;
      break;
    case 'In Progress':
      color = Colors.orange.shade800;
      background = Colors.orange.shade50;
      break;
    case 'Completed':
      color = Colors.green.shade800;
      background = Colors.green.shade50;
      break;
    case 'Cancelled':
      color = Colors.red.shade800;
      background = Colors.red.shade50;
      break;
    default:
      color = Colors.deepOrange.shade800;
      background = Colors.deepOrange.shade50;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 11),
    ),
  );
}

// SUMMARY CARD
Widget overviewCard(
  String title,
  String value,
  IconData icon, {
  Color color = primaryGreen,
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: borderSoft),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(height: 14),
        Text(
          value,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
  );
}

// EMPTY STATE
Widget emptyState(String message, IconData icon) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: fieldGrey,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Icon(icon, size: 42, color: accentGreen),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    ),
  );
}

// FEATURE TILE
Widget featureTile(IconData icon, String title, String description) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderSoft),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: primaryGreen),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'Requester';
  bool obscurePassword = true;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    try {
      final user = await ApiService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeShell(
            name:
                user['name']?.toString() ??
                emailController.text.split('@').first,
            role: user['role']?.toString() ?? role,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 78,
                    width: 78,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'HelpNear',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                const Center(
                  child: Text(
                    'Connecting people. Building stronger communities.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 38),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Sign in to continue to your account.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 25),
                const Text('Email address'),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Password'),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Sign in as'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Requester',
                      child: Text('Requester'),
                    ),
                    DropdownMenuItem(
                      value: 'Volunteer',
                      child: Text('Volunteer'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => role = value);
                    }
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Create one",
                      style: TextStyle(color: accentGreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// REGISTRATION SCREEN
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'Requester';

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final user = await ApiService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeShell(
            name: user['name']?.toString() ?? nameController.text.trim(),
            role: user['role']?.toString() ?? role,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Join HelpNear',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create an account and become part of a helpful community.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 28),
            const Text('Full name'),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Email address'),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Password'),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Create a password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Account type'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.group_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Requester', child: Text('Requester')),
                DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => role = value);
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MAIN NAVIGATION AND APP STATE
class HomeShell extends StatefulWidget {
  final String name;
  final String role;

  const HomeShell({super.key, required this.name, required this.role});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;
  List<HelpRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      final rows = await ApiService.getRequests();

      final loaded = rows.map<HelpRequest>((item) {
        return HelpRequest(
          id: item['id'].toString(),
          title: item['title']?.toString() ?? '',
          category: item['category']?.toString() ?? '',
          description: item['description']?.toString() ?? '',
          location: item['location']?.toString() ?? '',
          requester: item['requester']?.toString() ?? 'Requester',
          status: item['status']?.toString() ?? 'Pending',
          volunteer: item['volunteer']?.toString(),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        requests = loaded;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load requests: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  Future<void> refreshRequests() async {
    setState(() => isLoading = true);
    await loadRequests();
  }

  Future<void> acceptRequest(HelpRequest request) async {
    try {
      await ApiService.acceptRequest(int.parse(request.id));
      await refreshRequests();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> updateRequestStatus(HelpRequest request, String status) async {
    try {
      await ApiService.updateRequest(
        requestId: int.parse(request.id),
        status: status,
      );

      await refreshRequests();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request marked as $status')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> openSubmitRequest() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => SubmitRequestScreen(requesterName: widget.name),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await refreshRequests();
      if (!mounted) return;

      setState(() => selectedIndex = 1);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your request has been submitted')),
      );
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (_) {
      // Return to login even if the server logout request fails.
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRequester = widget.role == 'Requester';

    final pages = [
      isRequester
          ? RequesterDashboard(
              name: widget.name,
              requests: requests,
              onSubmit: openSubmitRequest,
            )
          : VolunteerDashboard(
              name: widget.name,
              requests: requests,
              onAccept: acceptRequest,
            ),
      isRequester
          ? MyRequestsScreen(
              name: widget.name,
              requests: requests,
              onStatusChange: updateRequestStatus,
            )
          : MyTasksScreen(
              name: widget.name,
              requests: requests,
              onStatusChange: updateRequestStatus,
            ),
      ProfileScreen(name: widget.name, role: widget.role, onLogout: logout),
    ];

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : IndexedStack(index: selectedIndex, children: pages),
      // Floating rounded crimson bar, like the Bite design
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() => selectedIndex = index);
            },
            height: 64,
            backgroundColor: primaryGreen,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.white24,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  isRequester ? Icons.home_outlined : Icons.dashboard_outlined,
                  color: Colors.white70,
                ),
                selectedIcon: const Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  isRequester ? Icons.assignment_outlined : Icons.task_outlined,
                  color: Colors.white70,
                ),
                selectedIcon: const Icon(Icons.assignment, color: Colors.white),
                label: isRequester ? 'My Requests' : 'My Tasks',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline, color: Colors.white70),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REQUESTER DASHBOARD
class RequesterDashboard extends StatelessWidget {
  final String name;
  final List<HelpRequest> requests;
  final VoidCallback onSubmit;

  const RequesterDashboard({
    super.key,
    required this.name,
    required this.requests,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final myRequests = requests.where((r) => r.requester == name).toList();

    final pending = myRequests.where((r) => r.status == 'Pending').length;
    final completed = myRequests.where((r) => r.status == 'Completed').length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HELPNEAR',
                        style: TextStyle(
                          color: accentGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Hello, $name',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      const Text(
                        'How can we help you today?',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: lightGreen,
                  child: Icon(Icons.person, color: primaryGreen),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryGreen, accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 35,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'A little help goes a long way.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect with people who are ready to support you in your community.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: onSubmit,
                    icon: const Icon(Icons.add),
                    label: const Text('Request Assistance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amber,
                      foregroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),
            sectionTitle('Your Overview'),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: overviewCard(
                    'My Requests',
                    '${myRequests.length}',
                    Icons.assignment_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: overviewCard(
                    'Pending',
                    '$pending',
                    Icons.hourglass_empty,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: overviewCard(
                    'Completed',
                    '$completed',
                    Icons.check_circle_outline,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            sectionTitle(
              'Recent Requests',
              subtitle: 'A quick look at your assistance requests',
            ),
            const SizedBox(height: 14),
            if (myRequests.isEmpty)
              emptyState(
                'You have not submitted any requests yet.',
                Icons.inbox_outlined,
              )
            else
              ...myRequests
                  .take(3)
                  .map((request) => RequestCard(request: request)),
          ],
        ),
      ),
    );
  }
}

// SUBMIT REQUEST SCREEN
class SubmitRequestScreen extends StatefulWidget {
  final String requesterName;

  const SubmitRequestScreen({super.key, required this.requesterName});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  String category = 'Shopping';

  final categories = [
    'Shopping',
    'Healthcare',
    'Household',
    'Transport',
    'Education',
    'Other',
  ];

  Future<void> submitRequest() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    try {
      await ApiService.createRequest(
        title: titleController.text.trim(),
        category: category,
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Assistance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us what you need',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Provide a few details so volunteers can understand how to assist you.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 25),
            const Text('Request title'),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Help with grocery shopping',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Category'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: categories
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => category = value);
                }
              },
            ),
            const SizedBox(height: 18),
            const Text('Description'),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Explain the assistance you need...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 18),
            const Text('General location'),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'e.g. Westlands, Nairobi',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: primaryGreen),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'For your privacy, only provide a general location here. Do not include your exact home address or sensitive personal details.',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Submit Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MY REQUESTS SCREEN
class MyRequestsScreen extends StatelessWidget {
  final String name;
  final List<HelpRequest> requests;
  final Future<void> Function(HelpRequest, String) onStatusChange;

  const MyRequestsScreen({
    super.key,
    required this.name,
    required this.requests,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final myRequests = requests
        .where((request) => request.requester == name)
        .toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'My Requests',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'View and track your assistance requests.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 22),
          if (myRequests.isEmpty)
            emptyState(
              'You have not submitted any requests yet.',
              Icons.inbox_outlined,
            )
          else
            ...myRequests.map(
              (request) => RequestCard(
                request: request,
                onStatusChange: onStatusChange,
                requesterView: true,
              ),
            ),
        ],
      ),
    );
  }
}

// VOLUNTEER DASHBOARD
class VolunteerDashboard extends StatelessWidget {
  final String name;
  final List<HelpRequest> requests;
  final Function(HelpRequest) onAccept;

  const VolunteerDashboard({
    super.key,
    required this.name,
    required this.requests,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final available = requests.where((r) => r.status == 'Pending').toList();

    final accepted = requests
        .where(
          (r) =>
              r.volunteer == name &&
              r.status != 'Completed' &&
              r.status != 'Cancelled',
        )
        .length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Hello, $name',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Make a difference today.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 23),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite_outline, color: Colors.white, size: 32),
                SizedBox(height: 12),
                Text(
                  'Your time can change someone’s day.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Browse available requests and offer support to people in your community.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          sectionTitle('Your Overview'),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: overviewCard(
                  'Available',
                  '${available.length}',
                  Icons.volunteer_activism,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: overviewCard(
                  'My Tasks',
                  '$accepted',
                  Icons.assignment_turned_in_outlined,
                  color: accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 27),
          sectionTitle(
            'Available Requests',
            subtitle: 'Choose a request you can help with.',
          ),
          const SizedBox(height: 13),
          if (available.isEmpty)
            emptyState(
              'There are no pending requests at the moment.',
              Icons.inbox_outlined,
            )
          else
            ...available.map(
              (request) => RequestCard(
                request: request,
                onAccept: () => onAccept(request),
              ),
            ),
        ],
      ),
    );
  }
}

// MY TASKS SCREEN
class MyTasksScreen extends StatelessWidget {
  final String name;
  final List<HelpRequest> requests;
  final Function(HelpRequest, String) onStatusChange;

  const MyTasksScreen({
    super.key,
    required this.name,
    required this.requests,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final myTasks = requests.where((r) => r.volunteer == name).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle(
            'My Tasks',
            subtitle: 'Manage the requests you have accepted.',
          ),
          const SizedBox(height: 20),
          if (myTasks.isEmpty)
            emptyState(
              'Requests you accept will appear here.',
              Icons.task_outlined,
            )
          else
            ...myTasks.map(
              (request) => RequestCard(
                request: request,
                onStatusChange: onStatusChange,
                volunteerView: true,
              ),
            ),
        ],
      ),
    );
  }
}

// REQUEST CARD
class RequestCard extends StatelessWidget {
  final HelpRequest request;
  final VoidCallback? onAccept;
  final Function(HelpRequest, String)? onStatusChange;
  final bool requesterView;
  final bool volunteerView;

  const RequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onStatusChange,
    this.requesterView = false,
    this.volunteerView = false,
  });

  void showDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestDetailsScreen(
          request: request,
          onStatusChange: onStatusChange,
          requesterView: requesterView,
          volunteerView: volunteerView,
          onAccept: onAccept,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDetails(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primaryGreen,
                    ),
                  ),
                ),
                statusBadge(request.status),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              request.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 15,
                  color: accentGreen,
                ),
                const SizedBox(width: 5),
                Text(
                  request.category,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: accentGreen,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.location,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (onAccept != null) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Accept Request'),
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'View details →',
                style: TextStyle(
                  color: accentGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// REQUEST DETAILS SCREEN
class RequestDetailsScreen extends StatelessWidget {
  final HelpRequest request;
  final Function(HelpRequest, String)? onStatusChange;
  final VoidCallback? onAccept;
  final bool requesterView;
  final bool volunteerView;

  const RequestDetailsScreen({
    super.key,
    required this.request,
    this.onStatusChange,
    this.onAccept,
    this.requesterView = false,
    this.volunteerView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.volunteer_activism,
                color: primaryGreen,
                size: 45,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ),
                statusBadge(request.status),
              ],
            ),
            const SizedBox(height: 20),
            sectionTitle('Description'),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: const TextStyle(height: 1.6, color: Colors.black87),
            ),
            const SizedBox(height: 22),
            sectionTitle('Request Information'),
            const SizedBox(height: 14),
            featureTile(Icons.category_outlined, 'Category', request.category),
            featureTile(
              Icons.location_on_outlined,
              'General location',
              request.location,
            ),
            featureTile(
              Icons.person_outline,
              'Requested by',
              request.requester,
            ),
            if (request.volunteer != null)
              featureTile(
                Icons.volunteer_activism,
                'Volunteer',
                request.volunteer!,
              ),
            const SizedBox(height: 20),
            if (onAccept != null && request.status == 'Pending')
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    onAccept!();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept Request'),
                ),
              ),
            if (volunteerView &&
                request.status != 'Completed' &&
                request.status != 'Cancelled') ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final nextStatus = request.status == 'Accepted'
                        ? 'In Progress'
                        : 'Completed';

                    onStatusChange?.call(request, nextStatus);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    request.status == 'Accepted'
                        ? 'Start Task'
                        : 'Mark as Completed',
                  ),
                ),
              ),
            ],
            if (requesterView &&
                request.status == 'Pending' &&
                onStatusChange != null) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    onStatusChange!(request, 'Cancelled');
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel Request',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.role,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle('My Profile'),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 39,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 43, color: primaryGreen),
                ),
                const SizedBox(height: 13),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(role, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'HelpNear Member',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          sectionTitle('Account Settings'),
          const SizedBox(height: 12),
          featureTile(
            Icons.person_outline,
            'Personal Information',
            'View your account details.',
          ),
          featureTile(
            Icons.notifications_none,
            'Notifications',
            'Manage your notification preferences.',
          ),
          featureTile(
            Icons.lock_outline,
            'Privacy & Security',
            'Keep your account information safe.',
          ),
          featureTile(
            Icons.help_outline,
            'Help & Support',
            'Get assistance using HelpNear.',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    title: const Text('Log out'),
                    content: const Text(
                      'Are you sure you want to log out of HelpNear?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          onLogout();
                        },
                        child: const Text(
                          'Log out',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE8CACA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Center(
            child: Text(
              'HelpNear • Community starts with helping',
              style: TextStyle(color: Colors.black38, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
