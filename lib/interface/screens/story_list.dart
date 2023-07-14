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

  Future<void> _getStories() async {
    return await _storiesProvider.getListOfStories();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return _getStories();
    });
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
    final listOfStoriesState = _storiesProvider.listOfStoriesState;

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
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () => widget.onGotoAddScreen(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
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
            body: RefreshIndicator(
              onRefresh: () => _getStories(),
              child: listOfStoriesState == ApiState.loading
                  ? const Center(child: Text('Loading Data...'))
                  : listOfStoriesState == ApiState.error
                      ? const Center(
                          child: Text(
                            'Check your Connection',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: stories.length,
                          itemBuilder: (builder, index) {
                            return ItemStory(
                              story: stories[index],
                              onTap: () =>
                                  widget.onGotoDetail(stories[index].id ?? ""),
                            );
                          }),
            ));
  }
}
