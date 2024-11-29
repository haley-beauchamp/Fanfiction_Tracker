import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/fanfic_with_review_display.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  static const String routeName = '/home/lists';
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final FanficService fanficService = FanficService();
  List<FanficWithReview> fanfics = [];
  String currentList = 'Read';
  String currentSort = '';

  @override
  void initState() {
    super.initState();
    getFanfics(currentList, null);
  }

  Future<void> getFanfics(String? selectedList, String? selectedSort) async {
    if (selectedList != null) {
      currentList = selectedList;
    }
    if (selectedSort != null) {
      currentSort = selectedSort;
    }

    List<FanficWithReview> fetchedFanfics =
        await fanficService.findFanficsByList(
      context: context,
      assignedList: currentList,
      assignedSort: currentSort,
    );
    setState(() {
      fanfics = fetchedFanfics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$currentList List',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          popupMenuTheme: const PopupMenuThemeData(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            color: GlobalVariables.dropdownColor,
                          ),
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.sort),
                          onSelected: (String selectedSort) {
                            getFanfics(null, selectedSort);
                          },
                          offset: const Offset(0, 50),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'title',
                              child: Text('Sort by Title'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'author',
                              child: Text('Sort by Author'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'fandom',
                              child: Text('Sort by Fandom'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'rating',
                              child: Text('Sort by Rating'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: const PopupMenuThemeData(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          color: GlobalVariables.dropdownColor,
                        ),
                      ),
                      child: PopupMenuButton(
                        icon: const Icon(Icons.list_alt),
                        onSelected: (String selectedList) {
                          getFanfics(selectedList, null);
                        },
                        offset: const Offset(0, 50),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Read',
                            child: Text('Read List'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'To-Read',
                            child: Text('To-Read List'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: fanfics.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                FanficWithReviewDisplay.routeName,
                arguments: fanfics[index],
              );
            },
            child: ListTile(
              title: Center(
                child: Text(
                  fanfics[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "By ${fanfics[index].author}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Fandom: ${fanfics[index].fandom}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              contentPadding:
                  const EdgeInsets.all(20), //good enough i guess???????
            ),
          );
        },
      ),
    );
  }
}
