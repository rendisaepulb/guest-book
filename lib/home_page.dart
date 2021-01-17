import 'package:flutter/material.dart';
import 'package:guest_book/helpers.dart';
import 'package:guest_book/new_guest_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'guest_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Guest> _guestBookList = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _guestBookList.addAll(Hive.box<Guest>(guestBookBoxName).values);
    });
  }

  void _addGuest(Guest guest) async {
    final box = Hive.box<Guest>(guestBookBoxName);

    await box.add(guest);

    setState(() {
      _guestBookList.add(guest);
    });

    _listKey.currentState.insertItem(0);
  }

  void _deleteGuest(int index, int reverseIndex, Guest item) async {
    final box = Hive.box<Guest>(guestBookBoxName);

    await box.deleteAt(reverseIndex);
    setState(() {
      _guestBookList.removeAt(reverseIndex);
    });

    _listKey.currentState.removeItem(
      index,
      (context, animation) => _CardItem(
        item: item,
        animation: animation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku Tamu'),
        bottom: _loading ? _LinearProgressWidget() : null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(10),
              initialItemCount: _guestBookList.length,
              itemBuilder: (context, index, animation) {
                final reverseIndex = (_guestBookList.length - 1) - index;
                final currentGuest = _guestBookList[reverseIndex];

                return _CardItem(
                  item: currentGuest,
                  animation: animation,
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SimpleDialog(
                          title: Text(
                            'Apakah Anda ingin mengapus ${currentGuest.name}?',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: OutlineButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteGuest(
                                    index,
                                    reverseIndex,
                                    currentGuest,
                                  );
                                },
                                child: Text('Ya'),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Tidak',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            if (_guestBookList.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 60,
                    ),
                    Text('No Data'),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Guest>(
            context,
            MaterialPageRoute(builder: (_) => NewGuestPage()),
          );

          if (result != null) _addGuest(result);
        },
        tooltip: 'Tambah Tamu',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _LinearProgressWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const _LinearProgressWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 4,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.red,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}

class _CardItem extends StatelessWidget {
  final Guest item;
  final Animation<double> animation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CardItem({
    Key key,
    this.item,
    this.animation,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          title: Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item.address,
          ),
          trailing: Text(
            DateFormat.Hms().format(item.arrivalDate),
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
