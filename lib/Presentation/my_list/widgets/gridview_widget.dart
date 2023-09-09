import 'package:catch_it_project/Presentation/my_list/downloads/functions_download.dart';
import 'package:catch_it_project/Presentation/product_view/product_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DownloadsGridview extends StatelessWidget {
  const DownloadsGridview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadedItem>>(
      future: getDownloadedPDFs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No downloaded PDFs yet.'));
        } else {
          final downloadedPDFs = snapshot.data;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 130,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3 / 4),
            itemCount: downloadedPDFs?.length,
            itemBuilder: (context, index) {
              // final pdfURL = downloadedPDFs?[index];
              final pdfInfo = downloadedPDFs![index];
              final pdfURL = pdfInfo.filePath;
              final imageUrl = pdfInfo.imageUrl;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfUrl: pdfURL),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Image(
                      image: Image.network(imageUrl).image,
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        Icons.domain_verification_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PDFViewController pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: widget.pdfUrl,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
        onError: (error) {
          print(error);
        },
        onRender: (pages) {
          print('Pages: $pages');
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            pdfViewController = vc;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pdfViewController != null) {
            pdfViewController
                .setPage(1); // Go to the first page (change as needed)
          }
        },
        child: const Icon(Icons.first_page),
      ),
    );
  }
}
