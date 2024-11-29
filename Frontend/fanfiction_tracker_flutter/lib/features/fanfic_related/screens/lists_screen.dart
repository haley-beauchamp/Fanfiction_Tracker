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

  @override
  void initState() {
    super.initState();
    getFanfics(currentList);
  }

  Future<void> getFanfics(String selectedList) async {
    currentList = selectedList;
    List<FanficWithReview> fetchedFanfics =
        await fanficService.findFanficsByList(
      context: context,
      assignedList: selectedList,
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
                          onSelected: (String value) {},
                          offset: const Offset(0, 50),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Author',
                              child: Text('Sort by Author'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Fandom',
                              child: Text('Sort by Fandom'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Rating',
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
                          getFanfics(selectedList);
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
