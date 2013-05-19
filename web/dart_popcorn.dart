import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;

@observable
var currentTime = 0;

@observable
var progress = 0;

List<Map<String, String>> bookmarkList = toObservable(new List());

skip(time) => js.context.video.currentTime(timeToSec(time));

timeToSec(time) {
  var timeArray = time.split(":");
  var timeInSec = (int.parse(timeArray[0]) * 60) + int.parse(timeArray[1]);
  return timeInSec;
}

void main() {
  var Popcorn = js.context.Popcorn;
 
  // Create a popcorn instance by calling the Youtube player plugin
  var video = js.retain(Popcorn.youtube('#video', 'https://www.youtube.com/watch?v=QFuCFUd2Zsw'));
  js.context.video = video;
  
  //Setup Callback for updating time
  video.on("timeupdate", new js.Callback.many((var time) => currentTime = js.context.video.currentTime().truncate()));
  video.on("timeupdate", new js.Callback.many((var time) => progress = (js.context.video.currentTime().truncate()/js.context.video.duration().truncate()) * 100));
  
  // play the video right away
  video.play();
  
  // Setup bookmarks
  bookmarkList.add({'name': "Intro", 'time': "00:00"});
  bookmarkList.add({'name': "Calling JavaScript from Dart (Google Charts API)", 'time': "03:15"});
  bookmarkList.add({'name': "Calling Dart from JavaScript (JSONP request to Twitter)", 'time': "10:35"});
  bookmarkList.add({'name': "Summary of interop APIs used so far", 'time': "14:57"});
  bookmarkList.add({'name': "Managing memory in a more complex app (Google Maps API)", 'time': "17:06"});
  bookmarkList.add({'name': "Summary of interop APIs related to managing memory", 'time': "23:46"});
  
  final String footnoteNode = "footnotediv";
  
  //Setup footnotes to diskplay bookmarks titles
  for (var i = 0; i < bookmarkList.length; i++) {
    var bookmark = bookmarkList[i];
    var nextBookmark = {'time': "999:00"};
    if(bookmarkList.length > i + 1){
      nextBookmark =  bookmarkList[i + 1];
    }
    video.footnote(js.map({'start': timeToSec(bookmark['time']), 'end': timeToSec(nextBookmark['time']),  'text': bookmark['name'], 'target': footnoteNode}));
  }
}