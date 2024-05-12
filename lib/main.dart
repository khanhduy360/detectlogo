import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo App Ẩn Thông Tin Vào Ảnh'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraApp(
                      cameras: cameras,
                    ),
                  ),
                );
              },
              child: Text('Chuyển cam'),
            ),
          ),
          Container(
            color: Colors.yellow,
            child: ElevatedButton(
              onPressed: () {
                decodeImage();
              },
              child: const Text('Decode Ảnh'),
            ),
          ),
          Container(
            color: Colors.yellow,
            child: ElevatedButton(
              onPressed: () {
                encodeImage("Ho va ten:  NKDUY, MSSV: 2222");
              },
              child: const Text('Encode Ảnh'),
            ),
          ),
          const Divider(),
          const Text('Hướng camera về phía mã QR'),
          Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.flash_on),
              Icon(Icons.camera),
              Icon(Icons.settings),
            ],
          ),
          Center(
            child: _imageFile == null
                ? const Text('No image selected.')
                : Image.file(_imageFile!),
          ),
          Center(
            child: _imageFile == null
                ? const Text('No image selected.')
                : ElevatedButton(
                    onPressed: () {
                      //uploadImage("Hãy mã hóa đi");
                    },
                    child: const Text('Up lên server'),
                  ),
          ),
        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  decodeImage() async {
    //final ImagePicker picker = ImagePicker();
    // Pick an image.
    // UploadTask uploadTask;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        //Upload to Firebase
        print(file.path);
        setState(() {
          _imageFile = File(image.path);
        });
        await sendImageDecode(_imageFile!);
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }


  encodeImage(String data) async {
    //final ImagePicker picker = ImagePicker();
    // Pick an image.
    // UploadTask uploadTask;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        //Upload to Firebase
        print(file.path);
        setState(() {
          _imageFile = File(image.path);
        });
        await sendImageEncode(_imageFile!, data);
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Future<void> sendImageEncode(File imageFile, String data) async {
    var request = http.MultipartRequest(
      'POST',
      // Uri.parse('http://192.168.1.5:8000/upload/'),
      Uri.parse('http://192.168.4.139:8000/encode/'),
    );
    // Thêm dữ liệu vào request
    request.fields['data'] = data;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var responseString = await streamedResponse.stream.bytesToString();
        print('Response: $responseString');
        print('Image uploaded successfully');
        // Xử lý thành công
      } else {
        print(
            'Failed to upload image. Error code: ${streamedResponse.statusCode}');
        setState(() {
          _errorMessage =
              'Failed to upload image. Error code: ${streamedResponse.statusCode}';
        });
        // Xử lý lỗi
      }
    } catch (e) {
      print('Failed to upload image. Error: $e');
      setState(() {
        _errorMessage = 'Failed to upload image. Error: $e';
      });
      // Xử lý lỗi
    }
  }

  Future<void> sendImageDecode(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      // Uri.parse('http://192.168.1.5:8000/upload/'),
      Uri.parse('http://192.168.4.139:8000/decode/'),
    );
    // Thêm dữ liệu vào request

    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var responseString = await streamedResponse.stream.bytesToString();
        print('Response: $responseString');
        print('Image uploaded successfully');
        // Xử lý thành công
      } else {
        print(
            'Failed to upload image. Error code: ${streamedResponse.statusCode}');
        setState(() {
          _errorMessage =
          'Failed to upload image. Error code: ${streamedResponse.statusCode}';
        });
        // Xử lý lỗi
      }
    } catch (e) {
      print('Failed to upload image. Error: $e');
      setState(() {
        _errorMessage = 'Failed to upload image. Error: $e';
      });
      // Xử lý lỗi
    }
  }
}
