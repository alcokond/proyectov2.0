import 'package:flutter_login_ui/api/apiDenuncias.dart';
import 'package:flutter_login_ui/notifier/auth_notifier.dart';
import 'package:flutter_login_ui/notifier/denuncia_notifier.dart';
import 'package:flutter_login_ui/screens/detail.dart';
import 'package:flutter_login_ui/screens/denuncia_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    DenunciaNotifier denunciaNotifier = Provider.of<DenunciaNotifier>(context, listen: false);
    getDenuncias(denunciaNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    DenunciaNotifier denunciaNotifier = Provider.of<DenunciaNotifier>(context);

    Future<void> _refreshList() async {
      getDenuncias(denunciaNotifier);
    }

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authNotifier.user != null ? authNotifier.user.displayName : "Feed",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                denunciaNotifier.denunciaList[index].imagen != null
                    ? denunciaNotifier.denunciaList[index].imagen
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(denunciaNotifier.denunciaList[index].nombre),
              subtitle: Text(denunciaNotifier.denunciaList[index].tipo),
              onTap: () {
                denunciaNotifier.currentDenuncia = denunciaNotifier.denunciaList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return denunciaDetail();
                }));
              },
            );
          },
          itemCount: denunciaNotifier.denunciaList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          denunciaNotifier.currentDenuncia = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return DenunciaForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}