
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DownloadedItem {
  final String filePath;
  final String imageUrl;
  final String title;

  DownloadedItem({
    required this.filePath,
    required this.imageUrl,
    required this.title,
  });

  factory DownloadedItem.fromJson(Map<String, dynamic> json) {
    return DownloadedItem(
      filePath: json['filePath'],
      imageUrl: json['imageUrl'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'imageUrl': imageUrl,
      'title': title,
    };
  }
}

Future<void> downloadAndStorePDF(
    String pdfUrl, String imageUrl, String title) async {
  final response = await http.get(Uri.parse(pdfUrl));

  if (response.statusCode == 200) {
    final directory = await getApplicationDocumentsDirectory();
    // final filePath = '${directory.path}/my_downloaded_pdf.pdf';
     final fileName = '${title}_${DateTime.now().millisecondsSinceEpoch}.pdf';
     final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);

    // Store the downloaded item in shared preferences
    final prefs = await SharedPreferences.getInstance();
    final downloadedItemsJson = prefs.getString('downloaded_items');
    List<DownloadedItem> downloadedItems = [];

    if (downloadedItemsJson != null) {
      final decodedItems = jsonDecode(downloadedItemsJson) as List<dynamic>;
      downloadedItems = decodedItems
          .map((itemJson) => DownloadedItem.fromJson(itemJson))
          .toList();
    }

    final newDownloadedItem = DownloadedItem(
      filePath: filePath,
      imageUrl: imageUrl,
      title: title,
    );

    downloadedItems.add(newDownloadedItem);

    final updatedItemsJson =
        jsonEncode(downloadedItems.map((item) => item.toJson()).toList());
    prefs.setString('downloaded_items', updatedItemsJson);

    Fluttertoast.showToast(
        msg: "Pdf downloaded", timeInSecForIosWeb: 1, fontSize: 16.0);
  } else {
    throw Exception('Failed to download PDF');
  }
}

