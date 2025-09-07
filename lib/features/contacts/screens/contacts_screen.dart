import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _loading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _loading = true;
      _permissionDenied = false;
    });

    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        _contacts = contacts.toList();
        _loading = false;
      });
    } else {
      setState(() {
        _permissionDenied = true;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contacts permission denied'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showContactSheet(Contact contact) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        contact.displayName ?? '',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (contact.phones != null && contact.phones!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          contact.phones!.first.value ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                if (contact.emails != null && contact.emails!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.green[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          contact.emails!.first.value ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contacts permission denied.\nPlease enable it in app settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchContacts,
              child: const Text('Request Permission'),
            )
          ],
        ),
      );
    }

    final itemPadding = isTablet ? 24.0 : 12.0;
    final cardElevation = isTablet ? 4.0 : 2.0;
    final avatarRadius = isTablet ? 32.0 : 24.0;
    final fontSizeTitle = isTablet ? 22.0 : 18.0;
    final fontSizeSubtitle = isTablet ? 18.0 : 14.0;

    if (isTablet) {
      // Grid for tablets
      return GridView.builder(
        padding: EdgeInsets.all(itemPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          crossAxisSpacing: itemPadding,
          mainAxisSpacing: itemPadding,
        ),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: cardElevation,
            child: ListTile(
              leading: CircleAvatar(
                radius: avatarRadius,
                child: const Icon(Icons.person, size: 32),
              ),
              title: Text(
                contact.displayName ?? 'No Name',
                style: TextStyle(fontSize: fontSizeTitle),
              ),
              subtitle: Text(
                contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? ''
                    : '',
                style: TextStyle(fontSize: fontSizeSubtitle),
              ),
              onTap: () => _showContactSheet(contact),
            ),
          );
        },
      );
    } else {
      // List for mobile
      return ListView.separated(
        padding: EdgeInsets.all(itemPadding),
        itemCount: _contacts.length,
        separatorBuilder: (_, __) => SizedBox(height: itemPadding / 2),
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: cardElevation,
            child: ListTile(
              leading: CircleAvatar(
                radius: avatarRadius,
                child: const Icon(Icons.person),
              ),
              title: Text(
                contact.displayName ?? 'No Name',
                style: TextStyle(fontSize: fontSizeTitle),
              ),
              subtitle: Text(
                contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? ''
                    : '',
                style: TextStyle(fontSize: fontSizeSubtitle),
              ),
              onTap: () => _showContactSheet(contact),
            ),
          );
        },
      );
    }
  }
}
