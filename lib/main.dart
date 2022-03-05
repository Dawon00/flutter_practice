import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
      home : MyApp()
   )
  );
}



class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      //print(contacts[0].familyName);
      setState(() {
        name = contacts;
      });

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  var total = 3;
  var like = [0,0,0];
  var name = [];

  addName(a){
    if (a == ''){
      return;
    }
    else{
      setState(() {
        name.add(a);
      });
    }
  }

  delete(i){
    setState(() {
      name.removeAt(i);
    });
  }

  addOne(){
    setState(() {
      total ++;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showDialog(context: context, builder: (context){
                return DialogUI( addOne : addOne, addName : addName );
              });
            },
            child: Text('+', style: TextStyle(fontSize: 30),),
          ),
            appBar: AppBar(title: Text('나의 연락처 (${name.length}명)'),
            actions: [
              IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))
            ],),
            bottomNavigationBar: BottomAppBar(),
            body: ListView.builder(
                itemCount: name.length,
                itemBuilder: (c, i){
                  return ListTile(
                    leading: Icon(Icons.account_circle, size: 30,),
                    title: Text(name[i].givenName),
                    trailing: TextButton(onPressed: (){delete(i);}, child: Text('delete'),),
                  );
                },
            )
            );


  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, this.addName}) : super(key: key);
  final addOne;
  final addName;
  var inputData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField( controller: inputData,),
            TextButton( child: Text('완료'),
              onPressed: (){
              var newContact = Contact();
              newContact.givenName = inputData.text;
              ContactsService.addContact(newContact);
              addName(newContact);
              Navigator.pop(context);
              },),
            TextButton( child: Text('취소'),
              onPressed: (){ Navigator.pop(context);},),

          ],
        ),
      )
    );
  }
}
