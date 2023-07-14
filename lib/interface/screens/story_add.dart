import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/static/enum.dart';

import 'package:submission_intermediate/providers/file_provider.dart';
import 'package:submission_intermediate/providers/stories_provider.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onSuccessUpload;
  const AddStoryScreen({super.key, required this.onSuccessUpload});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  Position? _currentPosition;
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _onGalleryView() async {
    final provider = context.read<FileProvider>();

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _upload() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final uploadProvider = context.read<StoriesProvider>();
    final fileProvider = context.read<FileProvider>();
    final imagePath = fileProvider.imagePath;
    final imageFile = fileProvider.imageFile;
    if (imagePath == null || imageFile == null) return;
    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    if (formKey.currentState!.validate()) {
      await uploadProvider.uploadStory(
          bytes,
          fileName,
          _descriptionController.text,
          _currentPosition!.latitude,
          _currentPosition!.longitude);

      if (uploadProvider.addResponse?.error == false) {
        fileProvider.setImageFile(null);
        fileProvider.setImagePath(null);
        scaffoldMessenger
            .showSnackBar(const SnackBar(content: Text('Success Uploaded')));
        context.read<StoriesProvider>().getListOfStories();
        widget.onSuccessUpload();
      } else {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text(uploadProvider.message)));
      }
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return _getCurrentPosition();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _onGalleryView(),
                child: Container(
                    width: double.maxFinite,
                    height: 350,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: context.watch<FileProvider>().imagePath == null
                        ? const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 100,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Click Here to Pick Image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          )
                        : _showImage()),
              ),
              const SizedBox(height: 22),
              context.watch<FileProvider>().imagePath != null
                  ? Container(
                      margin: const EdgeInsets.all(4),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please add Description.';
                          }
                          return null;
                        },
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      ),
                    )
                  : const Text(''),
              const SizedBox(height: 22),
              context.watch<FileProvider>().imagePath != null
                  ? GestureDetector(
                      onTap: () => _upload(),
                      child: Container(
                        width: double.maxFinite,
                        height: 54,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          child: Center(
                              child: context
                                          .watch<StoriesProvider>()
                                          .uploadStoryState ==
                                      ApiState.loading
                                  ? const CircularProgressIndicator()
                                  : context
                                              .watch<StoriesProvider>()
                                              .uploadStoryState ==
                                          ApiState.init
                                      ? const Text(
                                          'Upload',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text('')),
                        ),
                      ),
                    )
                  : const Text('')
            ],
          ),
        ),
      ),
    );
  }

  Widget _showImage() {
    final provider = context.read<FileProvider>();
    return FittedBox(
        clipBehavior: Clip.hardEdge,
        fit: BoxFit.cover,
        child: Image.asset(provider.imagePath ?? ""));
  }
}
