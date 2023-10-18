import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../Screens/SettingScreen.dart';
import 'home_viewmodel.dart';

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) {
        viewModel.temperatureAndLocation(); // Call initializeWeatherAndLocation
      },
      builder: (context, viewModel, child) {
        return HomeViewScreenContent(
          currentTemperature: viewModel.currentTemperature,
          currentLocation: viewModel.currentLocation,
          viewModel: viewModel,
        );
      },
    );
  }
}

class HomeViewScreenContent extends StatelessWidget {
  final HomeViewModel viewModel;
  final double currentTemperature;
  final String currentLocation;

  HomeViewScreenContent(
      {required this.viewModel,
      required this.currentTemperature,
      required this.currentLocation});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _showForm(BuildContext ctx, int? itemKey) async {
    _titleController.text = '';
    _quantityController.text = '';

    if (itemKey != null) {
      final existingItem = viewModel.getItemByKey(itemKey);

      _titleController.text = existingItem['title'] ?? '';
      _quantityController.text = existingItem['quantity'] ?? '';
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(hintText: 'Quantity'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text('Create New'),
              onPressed: () async {
                final title = _titleController.text.trim();
                final quantity = _quantityController.text.trim();

                if (title.isEmpty || quantity.isEmpty) {
                  showDialog(
                    context: ctx,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.green[200],
                        title: const Text('No Item'),
                        content: const Text('Please enter title and quantity'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  double temperature = currentTemperature;
                  String location = currentLocation;

                  if (itemKey == null) {
                    await viewModel.createItemWithWeatherAndLocation(
                      title: title,
                      quantity: quantity,
                      temperature: temperature,
                      location: location,
                    );
                  } else {
                    temperature = currentTemperature;
                    location = currentLocation;

                    viewModel.updateItem(itemKey, {
                      'title': title,
                      'quantity': quantity,
                      'temperature': temperature,
                      'location': location,
                    });
                  }

                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Icons'),
            ),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(viewModel),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: viewModel.getItemsCount(),
        itemBuilder: (context, index) {
          final item = viewModel.getItemByIndex(index);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            color: Colors.amber[300],
            child: ListTile(
              title: Text(item['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['quantity']),
                  Text('Temperature: ${item['temperature']}°C'),
                  Text('Location: ${item['location']}.'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showForm(context, item['key']);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.green[200],
                            title: const Text('Delete Item'),
                            content:
                                const Text('Are You Sure Want To Delete Item?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  viewModel.deleteItem(item['key']);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showForm(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
