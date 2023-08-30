import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watchlist/watchlist/helpers/constant.dart';
import 'package:watchlist/watchlist/models/group_model.dart';
import 'package:http/http.dart' as http;

part 'symbols_event.dart';
part 'symbols_state.dart';

class SymbolsBloc extends Bloc<SymbolsEvent, SymbolsState> {
  List<GroupModel> _symbolsList = [];
  List<GroupModel> symbolLocalList = [];
  List<Map<String, dynamic>> result = [];
  List sortLocalList = [];
  List<List<GroupModel>>dividedContacts=[];
  List<Map<String, dynamic>> sortResult = [
    // {
    //   "tabIndex": 0,
    //   "sortList": [ALPHABETICALLY_ASCENDING]
    // }
  ];
  SymbolsBloc() : super(SymbolsInitial()) {
      on<SymbolInitialFetchEvent>(symbolInitialFetchEvent);
          on<SymbolAddToListEvent>(symbolAddToGroupEvent);
    on<SymbolsAddToGroupEvent>(symbolsAddToGroupEvent);
        on<OpenBottomSheetEvent>(openBottomSheetEvent);
    on<SymbolsSortSingleAddEvent>(symbolsSortSingleAddEvent);

    on<SymbolsSortDoneEvent>(symbolsSortDone);


  }

   FutureOr<void> symbolInitialFetchEvent(
      SymbolInitialFetchEvent event, Emitter<SymbolsState> emit) async {
    emit(SymbolsBlocInitialFetchLoadingState());

    // _symbolsList = await SymbolsRepo.fetchPost();
print(sortResult);
    var client = http.Client();
    List<GroupModel> itemList = [];
    try {
      var response = await client.get(Uri.parse(
          'http://5e53a76a31b9970014cf7c8c.mockapi.io/msf/getContacts'));

      var result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        GroupModel post = GroupModel.fromJson(result[i]);
        post.checked = false;
        itemList.add(post);
      }
      _symbolsList = itemList;
 dividedContacts = _divideContactsIntoGroups(_symbolsList, 20);
 for (int i = 0; i < dividedContacts.length; i++) {
  print("Group ${i + 1}:");
  for (var contact in dividedContacts[i]) {
    print("Name: ${contact.name}, Contacts: ${contact.contacts}");
  }
}
      emit(SymbolsBlocInitialFetchSuccessState(
          symbols: dividedContacts, sortResult: sortResult));
    } catch (e) {
      emit(SymbolsFetchErrorState());
    }
  }
    List<List<GroupModel>> _divideContactsIntoGroups(List<GroupModel> contacts, int groupSize) {
    final dividedList = <List<GroupModel>>[];
    for (int i = 0; i < contacts.length; i += groupSize) {
      final group = contacts.sublist(i, i + groupSize > contacts.length ? contacts.length : i + groupSize);
      dividedList.add(group);
    }
    return dividedList;
  }


  FutureOr<void> symbolAddToGroupEvent(
      SymbolAddToListEvent event, Emitter<SymbolsState> emit) {
    // final existingCartItemIndex =
    //     dividedContacts.indexWhere((items) => items.id == event.groupModel.id);

    // if (existingCartItemIndex != -1) {
    //   final updatedSymbol = _symbolsList;
    //   updatedSymbol[existingCartItemIndex] = GroupModel(
    //     id: event.groupModel.id,
    //     url: event.groupModel.url,
    //     checkedNew: event.checked,
    //     name: event.groupModel.name,
    //     contacts: event.groupModel.contacts,
    //   );

    //   _symbolsList = updatedSymbol;
    // }
 for (var groupList in dividedContacts) {
    final index = groupList.indexWhere((item) => item.id == event.groupModel.id);
    if (index != -1) {
      print(event.groupModel.name);
      final updatedGroupModel = GroupModel(
        id: event.groupModel.id,
        url: event.groupModel.url,
        checkedNew:event. checked,
        name: event.groupModel.name,
        contacts: event.groupModel.contacts,
      );
      groupList[index] = updatedGroupModel;
      break; // Stop searching in other groups once found
    }
  }
    if (event.checked) {
      if (!symbolLocalList.contains(event.groupModel)) {
        symbolLocalList.add(event.groupModel);
      }
    } else {
      symbolLocalList.remove(event.groupModel);
    }
print(symbolLocalList.length);
    emit(SymbolsBlocInitialFetchSuccessState(
        symbols: dividedContacts, sortResult: sortResult));
  }

    FutureOr<void> symbolsAddToGroupEvent(
      SymbolsAddToGroupEvent event, Emitter<SymbolsState> emit) {
// List<GroupModel> groupModels = event.symbolLocalList;
//  Map<String, List<String>> groupedData = {};
    //  List<Map<String, dynamic>> resultAll = event.result;

    // for (var groupModel in groupModels) {
    //   if (!groupedData.containsKey(groupModel.name)) {
    //     groupedData[groupModel.name] = [];
    //   }
    //   groupedData[groupModel.name]!.add(groupModel.id);
    // }
    print("${event.groupName}${event.symbolLocalList}");
    symbolLocalList = [];

    Map<String, dynamic> groupMap = {
      'tabIndex': event.groupName,
      'symbols': event.symbolLocalList,
    };

    bool groupExists =
        result.any((item) => item['group_name'] == event.groupName);

    if (!groupExists) {
      result.add(groupMap);
    }
print("result is ${result}");
    emit(SymbolsAddedToGroupSuccessState(result: result));
    // print(result);
  }

  FutureOr<void> openBottomSheetEvent(OpenBottomSheetEvent event, Emitter<SymbolsState> emit) {
    emit(openBottomSheetSuccessEvent());
  } FutureOr<void> symbolsSortSingleAddEvent(
      SymbolsSortSingleAddEvent event, Emitter<SymbolsState> emit) {
    bool tabIndexExists = false;
    bool newItemExists = false;

    for (var i = 0; i < sortResult.length; i++) {
      if (sortResult[i]["tabIndex"] == event.tabSelected) {
        print("tab index alraedy present");
        tabIndexExists = true;
        if (!sortResult[i]["sortList"].contains(event.sort)) {
          print("adding item to sortlist");
          if (event.sort == ALPHABETICALLY_ASCENDING) {
            if (sortResult[i]["sortList"].contains(ALPHABETICALLY_DESCENDING)) {
              sortResult[i]["sortList"].add(event.sort);
              sortResult[i]["sortList"].remove(ALPHABETICALLY_DESCENDING);
            } else {
              sortResult[i]["sortList"].add(event.sort);
            }
          } else if (event.sort == ALPHABETICALLY_DESCENDING) {
            if (sortResult[i]["sortList"].contains(ALPHABETICALLY_ASCENDING)) {
              sortResult[i]["sortList"].add(event.sort);
              sortResult[i]["sortList"].remove(ALPHABETICALLY_ASCENDING);
            } else {
              sortResult[i]["sortList"].add(event.sort);
            }
          }
          if (event.sort == USERID_ASCENDING) {
            if (sortResult[i]["sortList"].contains(USERID_DESCENDING)) {
              sortResult[i]["sortList"].add(event.sort);
              sortResult[i]["sortList"].remove(USERID_DESCENDING);
            } else {
              sortResult[i]["sortList"].add(event.sort);
            }
          } else if (event.sort == USERID_DESCENDING) {
            if (sortResult[i]["sortList"].contains(USERID_ASCENDING)) {
              sortResult[i]["sortList"].add(event.sort);
              sortResult[i]["sortList"].remove(USERID_ASCENDING);
            } else {
              sortResult[i]["sortList"].add(event.sort);
            }
          }
          print(sortResult);
          emit(SymbolsBlocInitialFetchSuccessState(
              symbols: dividedContacts, sortResult: sortResult));
          // emit(SortListState(sortResult: sortResult));
          newItemExists = true;
        } else {
          print('trying to remove');
          sortResult[i]["sortList"].remove(event.sort);
          print(sortResult[i]["sortList"]);
          emit(SymbolsBlocInitialFetchSuccessState(
              symbols: dividedContacts, sortResult: sortResult));
        }
        break;
      }
    }

    if (!tabIndexExists) {
      sortResult.add({
        "tabIndex": event.tabSelected,
        "sortList": [event.sort]
      });

      print('new item adding');
      emit(SymbolsBlocInitialFetchSuccessState(
          symbols: dividedContacts, sortResult: sortResult));
    } else if (!newItemExists) {
      print('already present');
      emit(SymbolsBlocInitialFetchSuccessState(
          symbols: dividedContacts, sortResult: sortResult));

      // Handle the case where the tabIndex exists but the newItem is not present
      // ... Add your logic here if needed
    }
  }


  FutureOr<void> symbolsSortDone(SymbolsSortDoneEvent event, Emitter<SymbolsState> emit) {
    int tabSelected = event.tabSelected;
  List<String> sortList = event.sortList;

  // Create a copy of the dividedContacts list to modify only the selected tab's data
  List<List<GroupModel>> updatedDividedContacts = List.from(dividedContacts);

  // Find the group list based on the tabSelected
  List<GroupModel> groupList = updatedDividedContacts[tabSelected];

  // Sort the groupList based on the selected sorting criteria
  groupList.sort((a, b) {
    for (String sortCriteria in sortList) {
      switch (sortCriteria) {
        case ALPHABETICALLY_ASCENDING:
          int nameComparison = a.name.compareTo(b.name);
          if (nameComparison != 0) {
            return nameComparison;
          }
          break;
        case ALPHABETICALLY_DESCENDING:
          int nameComparison = b.name.compareTo(a.name);
          if (nameComparison != 0) {
            return nameComparison;
          }
          break;
        case USERID_ASCENDING:
          int useridComparison = int.parse(a.contacts).compareTo(int.parse(b.contacts));
          if (useridComparison != 0) {
            return useridComparison;
          }
          break;
        case USERID_DESCENDING:
          int useridComparison = int.parse(b.contacts).compareTo(int.parse(a.contacts));
          if (useridComparison != 0) {
            return useridComparison;
          }
          break;
      }
    }
    return 0; // Default case, no sorting
  });

  // Update the modified tab's data in the dividedContacts list
  updatedDividedContacts[tabSelected] = groupList;

  // Emit the updated state
  emit(SymbolsBlocInitialFetchSuccessState(
    symbols: updatedDividedContacts, sortResult: sortResult,
  ));
  }
}
