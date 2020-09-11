import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String videoFile;
  VideoViewer({this.videoFile});
  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       body: SafeArea(
//         child: InteractiveViewer(
//           maxScale: 5.0,
//           minScale: 0.1,
//           child: Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//               fit: BoxFit.contain,
//               image: NetworkImage(widget.imageFile),
//             )),
//           ),
//         ),
//       ),
//

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
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
          child: Center(
            child: _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _controller.seekTo(Duration(seconds: 0));
              });
            },
            child: Icon(
              Icons.replay,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
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
                onPressed: () {},
                icon: Icon(Icons.save_alt),
                label: Text(
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
