import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/static/enum.dart';
import 'package:submission_intermediate/core/utils/parser.dart';
import 'package:submission_intermediate/providers/stories_provider.dart';

class StoryDetail extends StatefulWidget {
  final String storyId;
  final Function(LatLng) onGotoLocation;
  const StoryDetail(
      {super.key, required this.storyId, required this.onGotoLocation});

  @override
  State<StoryDetail> createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  late StoriesProvider _storiesProvider;

  Future<void> getStoryDetail() async {
    return await _storiesProvider.getStoryDetail(widget.storyId);
  }

  Future<void> clearStoryDetail() async {
    return await _storiesProvider.clearDetailStory();
  }

  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return clearStoryDetail();
    });
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return getStoryDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _storiesProvider = Provider.of<StoriesProvider>(context);
    final story = _storiesProvider.currentStory;
    final detailState = _storiesProvider.detailStoryState;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: detailState == ApiState.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : detailState == ApiState.error
                  ? const Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.signal_cellular_connected_no_internet_4_bar,
                          size: 62,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Connection Timed Out  ',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ))
                  : detailState == ApiState.success
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(12),
                                width: double.maxFinite,
                                height: 350,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child:
                                        Image.network(story?.photoUrl ?? "")),
                              ),
                              Container(
                                margin: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story?.description ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      story?.name ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(12),
                                width: double.maxFinite,
                                height: 54,
                                decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Created At',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        timestampToHour(story?.createdAt ?? "",
                                            'dd MMMM, yyyy'),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              story?.lat != null || story?.lon != null
                                  ? GestureDetector(
                                      onTap: () => widget.onGotoLocation(LatLng(
                                          story?.lat ?? 0.0,
                                          story?.lon ?? 0.0)),
                                      child: Container(
                                        margin: const EdgeInsets.all(12),
                                        width: double.maxFinite,
                                        height: 54,
                                        decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: const Center(
                                              child: Text(
                                            'Open Google Map',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      ),
                                    )
                                  : const Text('')
                            ],
                          ),
                        )
                      : const Text('')),
    );
  }
}
