import 'package:hive_flutter/adapters.dart';

import 'package:stacked/stacked.dart';
import 'package:test/Services/Temperature.dart';

import '../../../Services/Location.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    refreshItems();
  }
  final _todoData = Hive.box('todo_data');
  List<Map<String, dynamic>> _items = [];

  final LocationService locationService = LocationService();
  final TemperatureService temperatureService = TemperatureService();

  double currentTemperature = 0.0;
  String currentLocation = 'Unknown';

  Future<void> temperatureAndLocation() async {
    try {
      final location = await locationService.getCurrentLocation();
      final temperature =
          await temperatureService.fetchCurrentTemperature(location);

      currentLocation = location;
      currentTemperature = temperature;
      notifyListeners();
    } catch (e) {
      print("Error fetching temperature or location: $e");
    }
  }

  Future<void> createItemWithWeatherAndLocation({
    required String title,
    required String quantity,
    required double temperature,
    required String location,
  }) async {
    final item = {
      "title": title,
      "quantity": quantity,
      "temperature": temperature,
      "location": location,
    };

    await _todoData.add(item);
    refreshItems();
  }

  void refreshItems() {
    final data = _todoData.keys.map((key) {
      final item = _todoData.get(key);
      return {
        "key": key,
        "title": item["title"],
        "quantity": item["quantity"],
        "temperature": item["temperature"],
        "location": item["location"],
      };
    }).toList();

    _items = data.reversed.toList();
    print(_items.length);
    notifyListeners();
  }

  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _todoData.add(newItem);
    refreshItems();
  }

  void updateItem(int itemKey, Map<String, dynamic> updatedItem) {
    _todoData.put(itemKey, updatedItem);
    refreshItems();
  }

  Future<void> deleteItem(int itemKey) async {
    await _todoData.delete(itemKey);
    refreshItems();
  }

  void deleteAllItems() async {
    await _todoData.clear();
    refreshItems();
    //rebuildUi();
  }

  Map<String, dynamic> getItemByKey(int itemKey) {
    return _items.firstWhere((element) => element['key'] == itemKey);
  }

  int getItemsCount() {
    return _items.length;
  }

  Map<String, dynamic> getItemByIndex(int index) {
    return _items[index];
  }
}
