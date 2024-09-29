import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bookingsCollection = FirebaseFirestore.instance.collection('bookings');

    return Card(
      color: const Color(0xFF1A1F37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Invoices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement VIEW ALL functionality if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58C6A9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    //add right margin to the button

                  ),
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Fetch invoices from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: bookingsCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .orderBy('notificationTime', descending: true)
                  .limit(5) // Limit to the latest 5 invoices
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bookings = snapshot.data!.docs;

                if (bookings.isEmpty) {
                  return const Center(
                    child: Text(
                      'No invoices found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Build a list of invoice items
                return Column(
                  children: bookings.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final notificationTime = data['notificationTime'] as Timestamp?;
                    String formattedDate = '';
                    if (notificationTime != null) {
                      final dateTime = notificationTime.toDate();
                      formattedDate = '${_formatMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
                    }

                    final invoiceNumber = '#${doc.id.substring(0, 8).toUpperCase()}'; // Shortened doc ID as invoice number
                    final amount = 'R ${data['price'] ?? 0}';

                    return _buildInvoiceItem(context, formattedDate, invoiceNumber, amount, data);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(BuildContext context, String date, String invoiceNumber, String amount, Map<String, dynamic> data) {
    return Card(
      color: const Color(0xFF2D3447),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF58C6A9),
          child: Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          invoiceNumber,
          style: const TextStyle(
            color: Color(0xFFA0AEC0),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _generateAndOpenPdf(context, data);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF58C6A9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: const Text(
            'OPEN PDF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _generateAndOpenPdf(BuildContext context, Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Extract data needed for the invoice
    final notificationTime = data['notificationTime'] as Timestamp?;
    String formattedDate = '';
    if (notificationTime != null) {
      final dateTime = notificationTime.toDate();
      formattedDate = '${_formatMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    }

    final price = data['price'] ?? 0;
    final zone = data['zone'] ?? '';
    final row = data['row'] ?? '';
    final level = data['level'] ?? '';
    final duration = data['duration'] ?? 0;
    final address = data['address'] ?? '';
    final userId = data['userId'] ?? '';
    final invoiceNumber = userId.substring(0, 8).toUpperCase();

    // Build the PDF content
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Date: $formattedDate'),
                    pw.Text('Invoice #: $invoiceNumber'),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Customer Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('User ID: $userId'),
                pw.SizedBox(height: 10),
                pw.Text('Parking Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: 'Location: $address'),
                pw.Bullet(text: 'Zone: $zone'),
                pw.Bullet(text: 'Row: $row'),
                pw.Bullet(text: 'Level: $level'),
                pw.Bullet(text: 'Duration: $duration hour(s)'),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Amount:',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'R$price',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Thank you for your business!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ],
            ),
          );
        },
      ),
    );

    // Display the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String _formatMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
