import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera.dart';
import 'network.dart';
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example JSON and ListView'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraApp(cameras: cameras,),
                  ),
                );
              },
              child: Text('Chuyển cam'),

            ),
          ),
          Divider(),
          Text('Hướng camera về phía mã QR'),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.flash_on),
              Icon(Icons.camera),
              Icon(Icons.settings),
            ],
          ),
        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.

  }
// _search(){
//   return Padding(
//       padding: const EdgeInsets.all(10),
//       child: TextField(
//       decoration: const InputDecoration(
//         hintText: 'Search....'
//       ),
//         onChanged: (text){
//         text = text.toLowerCase();
//         setState((){
//           _postsDisplay = _posts.where((post) {
//             var title = post.title!.toLowerCase();
//             return title.contains(text);
//           }).toList();
//         });
//         },
//     ),
//   );
// }
// _listRender(int index){
//   return Card(
//     child: Padding(
//       padding: const EdgeInsets.only(top: 32, bottom: 32, left: 16, right: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(_postsDisplay[index].url!),
//
//           ),
//           Text(
//             _postsDisplay[index].title!,
//             style: const TextStyle(
//                 fontSize: 22,fontWeight: FontWeight.bold
//             ),
//           ),
//
//
//
//         ],
//       ),
//     ),
//   );
// }
}

