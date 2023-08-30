import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist/bloc/symbols_bloc.dart';
import 'package:watchlist/watchlist/helpers/constant.dart';
import 'package:watchlist/watchlist/models/group_model.dart';

class Search1 extends StatefulWidget {
  const Search1({super.key, required this.groupName, required this.bloc});
  final String groupName;
  final SymbolsBloc bloc;
  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1>with SingleTickerProviderStateMixin {
    late TabController _tabController;
      int get currentTabIndex => _tabController.index;

  bool isAlphabeticallyAscending = false;
  bool isAlphabeticallyDescending = false;
  bool isUserIdAscending = false;
  bool isUserIdDescending = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    widget.bloc.add(SymbolInitialFetchEvent());
    // _tabController.addListener(
    // _handleTabChange); // Add this line to listen to tab changes
  }
    @override
  void dispose() {
    // _tabController.removeListener(_handleTabChange); // Remove the listener

    _tabController.dispose();

    super.dispose();
  }
 void _showValidationMsg() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Symbols not Selected'),
              content: const Text('Select atleast 1 symbol to create a group'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // NavigationHelper.navigatePop(context);
                    },
                    child: const Text('Ok'))
              ],
            ));
  }
   void _check(String sortItem) {
    int tabSeleted = _tabController.index;
// List<String>selectedSort=[];
// selectedSort.add(sortItem);
print("is tabinde${_tabController.index}");
    widget.bloc.add(
        SymbolsSortSingleAddEvent(tabSelected: tabSeleted, sort: sortItem));
  }
_showBottomSheet(){

showModalBottomSheet(context: context, builder: (BuildContext context) {
          return BlocBuilder<SymbolsBloc, SymbolsState>(
            bloc: widget.bloc,
            builder: (context, state) {

              switch (state.runtimeType) {
                // print(widget.bloc.sortResult);
                case SymbolsBlocInitialFetchSuccessState:
                  final successState =
                      state as SymbolsBlocInitialFetchSuccessState;

                  for (var map in successState.sortResult) {
                    if (map['tabIndex'] == _tabController.index) {
                      // print("present");
                      // isTabIndexPresent = true;

                      isAlphabeticallyAscending =
                          map['sortList'].contains(ALPHABETICALLY_ASCENDING);
                      isAlphabeticallyDescending =
                          map['sortList'].contains(ALPHABETICALLY_DESCENDING);
                      isUserIdAscending =
                          map['sortList'].contains(USERID_ASCENDING);
                      isUserIdDescending =
                          map['sortList'].contains(USERID_DESCENDING);
                      print("check ${isAlphabeticallyAscending}");

                      // for (var map1 in map["sortList"]) {
                      //                               print("passing inside ${map1}");

                      //   if (map1 == ALPHABETICALLY_ASCENDING) {
                      //     isAlphabeticallyAscending = true;
                      //   } else if (map1 == ALPHABETICALLY_DESCENDING) {
                      //     isAlphabeticallyDescending = true;
                      //   } else if (map1 == USERID_ASCENDING) {
                      //     isUserIdAscending = true;
                      //   } else if (map1 == USERID_DESCENDING) {
                      //     isUserIdDescending = true;
                      //   }
                      // }
                    }
                  }
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sorting',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    List<String> sortLocalList = [];
                                    if (isAlphabeticallyAscending) {
                                      sortLocalList
                                          .add(ALPHABETICALLY_ASCENDING);
                                    }
                                    if (isAlphabeticallyDescending) {
                                      sortLocalList
                                          .add(ALPHABETICALLY_DESCENDING);
                                    }
                                    if (isUserIdAscending) {
                                      sortLocalList.add(USERID_ASCENDING);
                                    }
                                    if (isUserIdDescending) {
                                      sortLocalList.add(USERID_DESCENDING);
                                    }
                                    if (sortLocalList.isNotEmpty) {
                                      widget.bloc.add(SymbolsSortDoneEvent(
                                          sortList: sortLocalList,
                                          tabSelected: _tabController.index));
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Alphabetically'),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text(
                                            'A',
                                            style: TextStyle(
                                                color: isAlphabeticallyAscending
                                                    ? Colors.blue
                                                    : Colors.black),
                                          ),
                                          Icon(
                                            Icons.arrow_upward,
                                            color: isAlphabeticallyAscending
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                          Text(
                                            'Z',
                                            style: TextStyle(
                                                color: isAlphabeticallyAscending
                                                    ? Colors.blue
                                                    : Colors.black),
                                          )
                                        ],
                                      ),
                                      onTap: () =>
                                          _check(ALPHABETICALLY_ASCENDING),
                                    ),
                                    const SizedBox(width: 20),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Z',
                                            style: TextStyle(
                                                color:
                                                    isAlphabeticallyDescending
                                                        ? Colors.blue
                                                        : Colors.black),
                                          ),
                                          Icon(Icons.arrow_downward,
                                              color: isAlphabeticallyDescending
                                                  ? Colors.blue
                                                  : Colors.black),
                                          Text(
                                            'A',
                                            style: TextStyle(
                                                color:
                                                    isAlphabeticallyDescending
                                                        ? Colors.blue
                                                        : Colors.black),
                                          )
                                        ],
                                      ),
                                      onTap: () =>
                                          _check(ALPHABETICALLY_DESCENDING),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(
                              height: 10,
                              color: Color.fromARGB(255, 186, 182, 182),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('User Id'),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                color: isUserIdAscending
                                                    ? Colors.blue
                                                    : Colors.black),
                                          ),
                                          Icon(Icons.arrow_upward,
                                              color: isUserIdAscending
                                                  ? Colors.blue
                                                  : Colors.black),
                                          Text('9',
                                              style: TextStyle(
                                                  color: isUserIdAscending
                                                      ? Colors.blue
                                                      : Colors.black))
                                        ],
                                      ),
                                      onTap: () => _check(USERID_ASCENDING),
                                    ),
                                    SizedBox(width: 20),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text('9',
                                              style: TextStyle(
                                                  color: isUserIdDescending
                                                      ? Colors.blue
                                                      : Colors.black)),
                                          Icon(Icons.arrow_downward,
                                              color: isUserIdDescending
                                                  ? Colors.blue
                                                  : Colors.black),
                                          Text('0',
                                              style: TextStyle(
                                                  color: isUserIdDescending
                                                      ? Colors.blue
                                                      : Colors.black))
                                        ],
                                      ),
                                      onTap: () => _check(USERID_DESCENDING),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return Text("o");
              }
            },
          );
        } );}
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
            title: const Text('Symbols'),
           ),floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(alignment: Alignment.bottomRight,
          // decoration: BoxDecoration(color: Colors.grey),
            width:double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                // Handle button press for the first button
_showBottomSheet();     
         },icon: Icon(Icons.sort),
              style: ElevatedButton.styleFrom(
                elevation: 8,
              ),
            ),
          ),
          const SizedBox(height: 10), // Add a spacing between the buttons
          Container(
            width:double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press for the second button
                // Add your logic here
                  if (widget.bloc.symbolLocalList.isNotEmpty) {
                  widget.bloc.add(SymbolsAddToGroupEvent(
                    groupName: widget.groupName,
                    symbolLocalList: widget.bloc.symbolLocalList,
                  ));
                  Navigator.of(context).pop();
                } else {
                  _showValidationMsg();
                }
              },
              child: const Text('Add to group'),
              style: ElevatedButton.styleFrom(
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      

      body: BlocConsumer<SymbolsBloc, SymbolsState>(
          bloc: widget.bloc,
          listener: (context, state) {
            // You can handle any additional UI-related logic here if needed
         
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case SymbolsBlocInitialFetchLoadingState:
                return const Center(child: CircularProgressIndicator());
              case SymbolsFetchErrorState:
                return const Center(child: Text('Error !!'));
              case SymbolsBlocInitialFetchSuccessState:
                final successState =
                    state as SymbolsBlocInitialFetchSuccessState;
                var dataList = successState.symbols;

                return DefaultTabController(
                  
                  length: dataList.length,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: List.generate(
                          dataList.length,
                          (index) => Tab(text: 'Symbols ${index + 1}'),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                                          controller: _tabController, // Pass the _tabController here

                          children: List.generate(
                            dataList.length,
                            (index) => ContactTab(
                                contacts: dataList[index], bloc: widget.bloc),
                          ),
                        ),
                      )
                    ],
                  ),
                );

              default:
                return const SizedBox(
                  height: 10,
                );
            }
            ;
          }),
    );
  }
}

class ContactTab extends StatelessWidget {
  final List<GroupModel> contacts;
  final SymbolsBloc bloc;

  const ContactTab({required this.contacts, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return
            // ListTile(
            //   title: Text(contacts[index].name),
            //   // Other contact details
            // );

            Container(
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 164, 231, 221),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contacts[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(contacts[index].contacts),
                      ],
                    ),
                  ),
                ],
              ),
              contacts[index].checkedNew
                  ? IconButton(
                      onPressed: () {
                        bloc.add(SymbolAddToListEvent(
                            groupModel: contacts[index], checked: false));
                      },
                      icon: const Icon(
                        Icons.check_circle_sharp,
                        size: 30,
                      ))
                  : IconButton(
                      onPressed: () {
                        bloc.add(SymbolAddToListEvent(
                            groupModel: contacts[index], checked: true));
                      },
                      icon: const Icon(
                        Icons.check_circle_outline_sharp,
                        size: 30,
                      ))
              // ElevatedButton(onPressed: onPressed, child: Text('Click'))
            ],
          ),
        );
      },
    );
  }
}
