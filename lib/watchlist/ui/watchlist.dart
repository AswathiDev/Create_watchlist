import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist/bloc/symbols_bloc.dart';
import 'package:watchlist/watchlist/helpers/navigation_helper.dart';
import 'package:watchlist/watchlist/ui/search.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late final SymbolsBloc _symbolBloc;

  TextEditingController groupNameController = TextEditingController();
  List<String> tabNames = ['Tab 1', 'Tab 2', 'Tab 3'];

  

  void _dismissBottomSheet(BuildContext context) {
    NavigationHelper.closeCurrentScreen(context);
  }

  @override
  void initState() {
    super.initState();
    print('init state');
    _symbolBloc = BlocProvider.of<SymbolsBloc>(
        context); // Access the SymbolsBloc instance
        print("init state in watchlist");
  }


  void _createWatchlist1() {
    groupNameController.clear();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 400,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Create Watchlist',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: groupNameController,
                        decoration: const InputDecoration(
                          label: Text('Enter watchlist name'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                          onPressed: () {
                            _dismissBottomSheet(context);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (cntx) => Search1(
                                      groupName: groupNameController.text,
                                      bloc: _symbolBloc,
                                    )));

                            // NavigationHelper.navigateToScreen(context, SearchScreen(groupName: groupNameController.text,));
                          },
                          child: const Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ]),
            ),
          );
        });
  }
  void _showValidationMsg(){
 showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 600, // Set the desired width
        height: 250, // Set the desired height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text('Group name is empty!'),
            const SizedBox(height: 10),
           const Text('Enter group name to continue'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    ),
  );
}
void _createWatchlist() {
  groupNameController.clear();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Watchlist',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter watchlist name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [ ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                              side: const BorderSide(color: Color.fromARGB(255,27,42,82),), // Border color

                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color.fromARGB(255,27,42,82),),
                        ),
                      ),
                    const  SizedBox(width: 10,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255,27,42,82),
                            ),
                            onPressed: () {
                              if(groupNameController.text.isNotEmpty){
 Navigator.pop(context); // Close the dialog
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (cntx) => Search1(
                                  groupName: groupNameController.text,
                                  bloc: _symbolBloc,
                                ),
                              ));
                              }
                             else{
                              _showValidationMsg();
                             }
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

//   @override
//   Widget build(BuildContext context) {

//     return DefaultTabController(
//         length:_symbolBloc.result.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Watchlist',
//             style: TextStyle(color: Colors.white),
//           ),  bottom: TabBar(
//             tabs: tabNames.map((String tabName) {
//               return Tab(text: tabName);
//             }).toList(),

//           ),
//           backgroundColor: const Color.fromARGB(255, 10, 153, 132),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   _createWatchlist();
//                 },
//                 icon: const Icon(
//                   Icons.add,
//                   color: Colors.white,
//                 ))
//           ],
//         ),
//  body: TabBarView(
//           children: tabNames.map((String tabName) {
//             return Center(child: Text('Content of $tabName'));
//           }).toList(),
//         ),
//       ),
//     );
//   }

Widget _renderWatchListEmpty(){
  return   Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Watchlist',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color.fromARGB(255,27,42,82),
                actions: [
                  IconButton(
                      onPressed: () {
                        _createWatchlist();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              ),
              body: Center(
                child:Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6XckElnl3xZemGoM4MtR3UPFP6l693I4wcXxaGbOt6AimXUiPPgOtGbIvaEw_Tz9zLy8&usqp=CAU',),
                                  const  Text('Watchlist is empty'),
 ],
                ),
                 
              ));
}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SymbolsBloc, SymbolsState>(
      bloc: _symbolBloc,
      listener: (context, state) {
        // ... listener code
      },
      builder: (context, state) {
        print('error0');
        if (state is SymbolsAddedToGroupSuccessState) {
          final successState = state;
          // tabNames = state.result
          //     .map((group) => group["group_name"] as String)
          //     .toList();
print("result is in ${successState.result?.length}");
if(successState.result.length>0){
 return DefaultTabController(
            length: successState.result.length,
            child: Scaffold(
              appBar: AppBar(                                backgroundColor: Color.fromARGB(255,27,42,82),


                title: const Text(
                  'Watchlist',
                  
                  style: TextStyle(color: Colors.white),
                ),
      //           bottom: TabBar(isScrollable: true, // Allow tabs to scroll if needed
      // indicatorSize: TabBarIndicatorSize.label,
      //       labelPadding: const EdgeInsets.only(left: 16.0), // Adjust left padding

      //             // tabs: tabNames.map((String tabName) {
      //             //   return Tab(text: tabName);
      //             // }).toList(),
      //             tabs: successState.result.map((group) {
      //               return Align(alignment: Alignment.bottomRight, child: Tab(text: group["tabIndex"]));
      //             }).toList(),
      //           ),
      bottom: LeftAlignedTabBar(
    tabs: successState.result.map((group) {
      return Tab( text: group["tabIndex"]);
    }).toList(),
  ),
                actions: [
                  IconButton(
                      onPressed: () {
                        _createWatchlist();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))
                ],
              ),
              body: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight, colors: [Color.fromARGB(255, 234,238,241),Color.fromARGB(255, 125, 126, 128)])),
                child: TabBarView(
                  children: state.result.map((group) {
                    // return Center(child: Text(group["symbols"]));
                    return ListView.builder(
                      itemCount: group["symbols"].length,
                      itemBuilder: (context, index) => Card( color: Color.fromARGB(255, 255, 255, 255),
              
                        child: Container( 
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: 
                              
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              group["symbols"][index].name,
                                              style:const  TextStyle(
                                                color: Color.fromARGB(255,101,110,138),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(group["symbols"][index].contacts,
                                              style:const  TextStyle(
                                                color: Color.fromARGB(255,117,182,196),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                       Image.asset(
                                      'images/user.jpg',
                                      fit: BoxFit.contain,height: 50,width:50,
                                    ),
                                      ],
                                    ),
                                  ),
                               
                      
                              // ElevatedButton(onPressed: onPressed, child: Text('Click'))
                            
                          
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
}
else{
      return    _renderWatchListEmpty();

}
         
        } else {
       return   _renderWatchListEmpty();
          // Loading state
        }
      },
    );
  }
}
class LeftAlignedTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;

 const LeftAlignedTabBar({super.key,  required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(                color: Color.fromARGB(255,27,42,82),

      child: Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Color.fromARGB(255, 186, 179, 179),
          tabs: tabs,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding:const EdgeInsets.only(left: 20.0), // Adjust left padding
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>const Size.fromHeight(kToolbarHeight);
}
