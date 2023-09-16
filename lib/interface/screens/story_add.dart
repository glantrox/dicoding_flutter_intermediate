import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/static/enum.dart';

import 'package:submission_intermediate/providers/file_provider.dart';
import 'package:submission_intermediate/providers/map_provider.dart';
import 'package:submission_intermediate/providers/stories_provider.dart';
import '../../core/utils/image_picker.dart';
import '../widget/image_picker.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onSuccessUpload;
  final Function onGotoSetLocation;
  const AddStoryScreen(
      {super.key,
      required this.onSuccessUpload,
      required this.onGotoSetLocation});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  late MapProvider _mapProvider;
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _getCurrentLatlng() async {
    return _mapProvider.getCurrentPosition(context);
  }

  _upload() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final uploadProvider = context.read<StoriesProvider>();
    final fileProvider = context.read<FileProvider>();
    final mapProvider = context.read<MapProvider>();
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
          _mapProvider.currentLatLng!.latitude,
          _mapProvider.currentLatLng!.longitude);

      if (uploadProvider.addResponse?.error == false) {
        fileProvider.setImageFile(null);
        fileProvider.setImagePath(null);
        scaffoldMessenger
            .showSnackBar(const SnackBar(content: Text('Success Uploaded')));
        uploadProvider.uploadStoryState = ApiState.init;
        uploadProvider.clearListOfStories();
        uploadProvider.getListOfStories();
        mapProvider.clearLatLng();

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
      return _getCurrentLatlng();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mapProvider = Provider.of<MapProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => onGalleryView(context),
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
                        : showImage(context),
                  ),
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
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () => widget.onGotoSetLocation(),
                            child: Container(
                              width: double.maxFinite,
                              height: 54,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: const Center(
                                  child: Text(
                                    'Set Location',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Visibility(
                            visible: _mapProvider.currentLatLng == null
                                ? false
                                : true,
                            child: GestureDetector(
                              onTap: () => _upload(),
                              child: Container(
                                width: double.maxFinite,
                                height: 54,
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Center(
                                      child: context
                                                  .watch<StoriesProvider>()
                                                  .uploadStoryState ==
                                              ApiState.loading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : context
                                                      .watch<StoriesProvider>()
                                                      .uploadStoryState ==
                                                  ApiState.init
                                              ? const Text(
                                                  'Upload',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              : Text('')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
