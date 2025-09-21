import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:focus_field/models/silence_data.dart';

enum ExportFormat { csv, pdf }

class ExportService {
  static ExportService? _instance;
  static ExportService get instance => _instance ??= ExportService._();
  ExportService._();

  /// Export session data as CSV file
  Future<File> exportToCSV(SilenceData silenceData) async {
    try {
      // Create CSV data
      final List<List<dynamic>> csvData = [
        // Header row
        [
          'Date',
          'Duration (minutes)',
          'Points Earned',
          'Average Noise (dB)',
          'Completed',
          'Success Rate',
        ],
      ];

      // Add session data
      for (final session in silenceData.recentSessions) {
        csvData.add([
          session.date.toIso8601String(),
          (session.duration / 60).toStringAsFixed(1),
          session.pointsEarned,
          session.averageNoise.toStringAsFixed(1),
          session.completed ? 'Yes' : 'No',
          session.completed ? '100%' : '0%',
        ]);
      }

      // Add summary row
      csvData.add([]);
      csvData.add(['Summary Statistics', '', '', '', '', '']);
      csvData.add(['Total Points', silenceData.totalPoints, '', '', '', '']);
      csvData.add([
        'Total Sessions',
        silenceData.totalSessions,
        '',
        '',
        '',
        '',
      ]);
      csvData.add([
        'Current Streak',
        silenceData.currentStreak,
        '',
        '',
        '',
        '',
      ]);
      csvData.add(['Best Streak', silenceData.bestStreak, '', '', '', '']);

      // Convert to CSV string
      final String csvString = const ListToCsvConverter().convert(csvData);

      // Get file path
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().toIso8601String().split('T')[0];
      final file = File('${directory.path}/FocusField_Export_$timestamp.csv');

      // Write to file
      await file.writeAsString(csvString);
      return file;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  /// Export session data as PDF report
  Future<File> exportToPDF(SilenceData silenceData) async {
    try {
      final pdf = pw.Document();

      // Calculate summary statistics
      final completedSessions =
          silenceData.recentSessions.where((s) => s.completed).length;
      final successRate =
          silenceData.recentSessions.isNotEmpty
              ? (completedSessions / silenceData.recentSessions.length * 100)
                  .toStringAsFixed(1)
              : '0.0';

      final averagePoints =
          silenceData.recentSessions.isNotEmpty
              ? (silenceData.recentSessions
                          .map((s) => s.pointsEarned)
                          .reduce((a, b) => a + b) /
                      silenceData.recentSessions.length)
                  .toStringAsFixed(1)
              : '0.0';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Focus Field Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // Summary section
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Summary Statistics',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Points: ${silenceData.totalPoints}'),
                        pw.Text('Total Sessions: ${silenceData.totalSessions}'),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Current Streak: ${silenceData.currentStreak}'),
                        pw.Text('Best Streak: ${silenceData.bestStreak}'),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Success Rate: $successRate%'),
                        pw.Text('Average Points: $averagePoints'),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Session history header
              pw.Text(
                'Recent Session History',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 16),

              // Session history table
              if (silenceData.recentSessions.isNotEmpty) ...[
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey100,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Date',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Duration',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Points',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Avg Noise',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Status',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Data rows
                    ...silenceData.recentSessions.map(
                      (session) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${session.date.day}/${session.date.month}/${session.date.year}',
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${(session.duration / 60).toStringAsFixed(1)}m',
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${session.pointsEarned}'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '${session.averageNoise.toStringAsFixed(1)} dB',
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              session.completed ? '✓ Complete' : '✗ Incomplete',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Center(child: pw.Text('No session data available')),
                ),
              ],

              pw.SizedBox(height: 30),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Report generated on ${DateTime.now().toString().split(' ')[0]}',
                  style: const pw.TextStyle(color: PdfColors.grey),
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF to file
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().toIso8601String().split('T')[0];
      final file = File('${directory.path}/FocusField_Report_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  /// Share exported file
  Future<void> shareFile(File file, String title) async {
    try {
      // ShareParams / SharePlus are available in share_plus ^11.x.
      final params = ShareParams(
        files: [XFile(file.path)],
        text: title,
        subject: 'Focus Field Export',
      );
      await SharePlus.instance.share(params);
    } catch (e) {
      throw Exception('Failed to share file: $e');
    }
  }

  /// Export and share CSV
  Future<void> exportAndShareCSV(SilenceData silenceData) async {
    final file = await exportToCSV(silenceData);
    await shareFile(file, 'Focus Field Session Data Export');
  }

  /// Export and share PDF
  Future<void> exportAndSharePDF(SilenceData silenceData) async {
    final file = await exportToPDF(silenceData);
    await shareFile(file, 'Focus Field Performance Report');
  }
}
