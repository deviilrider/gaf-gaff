import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageViewer extends StatefulWidget {
  final String imageFile;
  ImageViewer({this.imageFile});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File _imageFile;
  int _progress = 0;
  bool downloading = false;

  @override
  void initState() {
    super.initState();

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: InteractiveViewer(
          maxScale: 5.0,
          minScale: 0.1,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(widget.imageFile),
            )),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white60,
                onPressed: () {},
                icon: Icon(Icons.add_circle),
                label: Text(
                  'Story',
                  overflow: TextOverflow.ellipsis,
                )),
            FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white60,
                onPressed: downloading
                    ? () {}
                    : () {
                        _downloadImage(widget.imageFile);
                        setState(() {
                          downloading = true;
                        });
                      },
                icon: Icon(Icons.save_alt),
                label: downloading
                    ? Text(
                        "$_progress Downloading.. ",
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        'Save',
                        overflow: TextOverflow.ellipsis,
                      )),
            FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white60,
                onPressed: () {},
                icon: Icon(Icons.ios_share),
                label: Text(
                  'Forward',
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage(String url,
      {AndroidDestinationType destination,
      bool whenError = false,
      String outputMimeType}) async {
    String fileName;
    String path;
    int size;
    String mimeType;
    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
                outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            var path = "";
            if (error.code == "404") {
              print("Not Found Error.");

              setState(() {
                downloading = false;
              });
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];

              setState(() {
                downloading = false;
              });
            }
            setState(() {
              _message = error.toString();
              _path = path;
              downloading = false;
            });
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");

          setState(() {
            downloading = false;
          });
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
          setState(() {
            downloading = false;
          });
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
          setState(() {
            downloading = false;
          });
        }
      }

      if (imageId == null) {
        setState(() {
          downloading = false;
        });
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      setState(() {
        _message = error.message;

        downloading = false;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;

      downloading = false;

      if (!_mimeType.contains("video")) {
        _imageFile = File(path);

        setState(() {
          downloading = false;
        });
      }
      return;
    });
  }
}
