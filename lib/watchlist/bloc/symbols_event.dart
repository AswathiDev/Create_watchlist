part of 'symbols_bloc.dart';

@immutable
sealed class SymbolsEvent {}
class SymbolInitialFetchEvent extends SymbolsEvent{
}
class SymbolLoadingEvent extends SymbolsEvent{}
class SymbolAddToListEvent extends SymbolsEvent{
final  GroupModel groupModel;
 final bool checked;
  SymbolAddToListEvent({required this.groupModel,required this.checked});
}
class SymbolsAddToGroupEvent extends SymbolsEvent{
 final String groupName;
    List<GroupModel> symbolLocalList = [];
    // List<Map<String, dynamic>> result = [];

  SymbolsAddToGroupEvent({required this.groupName,required this.symbolLocalList});
}
class OpenBottomSheetEvent extends SymbolsEvent{

}
class SymbolsSortDoneEvent extends SymbolsEvent{
   int tabSelected;
    List<String> sortList = [];
    SymbolsSortDoneEvent({required this.tabSelected,required this.sortList});
}
class SymbolsSortSingleAddEvent extends SymbolsEvent{
  late int tabSelected;
 late String sort ;
    SymbolsSortSingleAddEvent({required this.tabSelected,required this.sort});
}