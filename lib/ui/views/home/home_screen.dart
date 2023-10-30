import 'package:flutter/material.dart';
import 'package:test/Screens/SettingScreen.dart';
import 'package:test/Services/Location.dart';
import 'package:test/Services/Temperature.dart';
import 'package:test/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final LocationService locationService = LocationService();
  final TemperatureService temperatureService = TemperatureService();

  double currentTemperature = 0.0;
  String currentLocation = 'Unknown';

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  //get all data from database

  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
      _titleController.text = '';
      _descController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> _addData() async {
    final title = _titleController.text;
    final description = _descController.text;
    final temperature =
        await temperatureService.fetchCurrentTemperature(currentLocation);
    final location = await locationService.getCurrentLocation();
    currentLocation = location as String;
    currentTemperature = temperature as double;

    await SQLHelper.createData(
        title, description, temperature, location as String);
    refreshData();
  }

//update data
  Future<void> _updateData(int id) async {
    final temperature =
        await temperatureService.fetchCurrentTemperature(currentLocation);
    final location = await locationService.getCurrentLocation();
    currentLocation = location as String;
    currentTemperature = temperature as double;

    await SQLHelper.updateData(
        id,
        _titleController.text,
        _descController.text, // Use the text from the controller
        temperature,
        location as String);
    refreshData();
  }

  //delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('message deleted'),
      backgroundColor: Colors.redAccent,
    ));
    refreshData();
  }

  void showBottomSheet(int? id) {
    if (id != null) {
      final _existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = _existingData['title'];
      _descController.text = _existingData['desc'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () {
                  final title = _titleController.text;
                  final desc = _descController.text;

                  if (id == null && (title.isEmpty || desc.isEmpty)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.green[200],
                            title: Text('No Items'),
                            content: Text(' Enter Title And Description'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'))
                            ],
                          );
                        });
                  } else {
                    if (id == null) {
                      _addData();
                    } else {
                      _updateData(id);
                    }
                    Navigator.of(context).pop();
                    print('data added');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    id == null ? 'Add Data' : 'Update',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Data'),
        backgroundColor: Colors.green,
      ),
      drawer: SizedBox(
        width: 200,
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                  child: Text(
                'Items',
                style: TextStyle(fontSize: 18),
              )),
            ),
            ListTile(
              title: Text('Delete All'),
              leading: Icon(Icons.delete, color: Colors.redAccent),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            )
          ]),
        ),
      ),
      body: ListView.builder(
          itemCount: _allData.length,
          itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]['title'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_allData[index]['desc']),
                      Text('Temperature:${_allData[index]['temperature']}'),
                      Text('Location:${_allData[index]['location']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => showBottomSheet(_allData[index]['id']),
                        icon: Icon(Icons.edit, color: Colors.indigo),
                      ),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.green[200],
                                  title: Text('Delete Item'),
                                  content: Text('Are You Sure want To Delete'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        _deleteData(_allData[index]['id']);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          })
                    ],
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
