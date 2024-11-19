import 'package:flutter/material.dart';
import 'package:guided/helper/db_helper.dart';

class IsiDatabase extends StatefulWidget {
  const IsiDatabase({super.key});

  @override
  State<IsiDatabase> createState() => _IsiDatabaseState();
}

class _IsiDatabaseState extends State<IsiDatabase> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _dbData = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _refreshData() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      _dbData = allRows;
    });
  }

  void _addData() async {
    await dbHelper.insert({
      'title': _titleController.text,
      'description': _descriptionController.text
    });
    _titleController.clear();
    _descriptionController.clear();
    _refreshData();
  }

  void deleteData(int id) async {
    await dbHelper.delete(id);
    _refreshData();
  }

  // ignore: unused_element
  void _showEditDialog(Map<String, dynamic> row) {
    _titleController.text = row['title'];
    _descriptionController.text = row['description'];

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateData(row['id']);
                  },
                  child: const Text('Save')),
            ],
          );
        });
    @override
    Widget(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Database Example'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ),
            ElevatedButton(onPressed: _addData, child: Text("Add Data")),
            ElevatedButton(onPressed: _addData, child: Text("Add Data")),
            Expanded(child: ListView.builder
              (itemCount: _dbData.length, itemBuilder: (context, index) {
                final item = _dbData[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteData(item['id']),
                      ),
                    ],
                  );
                  },),
        )],
        ),
      );
    }
  }

  void _updateData(int id) async {
    await dbHelper.update({
      'id': id,
      'title': _titleController.text,
      'description': _descriptionController.text
    });
    _titleController.clear();
    _descriptionController.clear();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Example'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          ElevatedButton(
            onPressed: _addData,
            child: const Text('Add Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dbData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_dbData[index]['title']),
                  subtitle: Text(_dbData[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
