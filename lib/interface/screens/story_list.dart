import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/static/enum.dart';
import 'package:submission_intermediate/interface/static/app_colors.dart';
import 'package:submission_intermediate/interface/widget/item_story.dart';
import 'package:submission_intermediate/providers/stories_provider.dart';

class StoryList extends StatefulWidget {
  final Function onLogout;

  final Function onGotoAddScreen;
  final Function(String) onGotoDetail;
  const StoryList(
      {super.key,
      required this.onGotoAddScreen,
      required this.onGotoDetail,
      required this.onLogout});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  bool _isLogoutDialogVisible = false;
  late StoriesProvider _storiesProvider;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    final apiProvider = context.read<StoriesProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (apiProvider.currentPageItems != null) {
          apiProvider.getListOfStories();
        }
      }
    });

    Future.microtask(() async => apiProvider.getListOfStories());
    super.initState();
  }

  _toggleLogoutDialog(bool value) {
    setState(() {
      _isLogoutDialogVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _storiesProvider = Provider.of<StoriesProvider>(context);
    final stories = _storiesProvider.listOfStories;
    final storyState = _storiesProvider.listOfStoriesState;

    return _isLogoutDialogVisible
        ? StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Log-out?'),
                content: const Text('Are you sure want to Log-out?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => _toggleLogoutDialog(false),
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () => widget.onLogout(),
                  ),
                ],
              );
            },
          )
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            floatingActionButton: Visibility(
              visible:
                  storyState == ApiState.loading || storyState == ApiState.error
                      ? false
                      : true,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => widget.onGotoAddScreen(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () => _toggleLogoutDialog(true),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ))
              ],
              backgroundColor: AppColors.backgroundColor,
              title: const Text('Story list'),
            ),
            body: Consumer<StoriesProvider>(
              builder: (context, value, child) {
                final state = value.listOfStoriesState;
                if (state == ApiState.loading && value.currentPageItems == 1) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                } else if (state == ApiState.success) {
                  return RefreshIndicator(
                    onRefresh: () {
                      _storiesProvider.clearDetailStory();
                      return _storiesProvider.getListOfStories();
                    },
                    child: ListView.builder(
                        itemCount: stories.length +
                            (value.currentPageItems != null ? 1 : 0),
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index == stories.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(22),
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return ItemStory(
                            story: stories[index],
                            onTap: () =>
                                widget.onGotoDetail(stories[index].id ?? ""),
                          );
                        }),
                  );
                } else {
                  return const Center(
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
                  ));
                }
              },
            ));
  }
}
