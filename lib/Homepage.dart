import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'displaycontacts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getPermi();//getting user permissions for contacts in background
    super.initState();

  }
  var details = Map();//to store the contact details of users
  getPermi()async {
    final PermissionStatus permissionStatus = await _getPermission();//calling the function get permissions
    if (permissionStatus == PermissionStatus.granted) //if the permission is granted we call getContacts() function
        {
      getContacts();//used to get contacts
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;//getting the status of the permission
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) //if permission is neither granted nor denied
        {
      final Map<Permission, PermissionStatus> permissionStatus = await [Permission.contacts].request();//requesting user for permission
      return permissionStatus[Permission.contacts] ?? PermissionStatus.undetermined;//returns the permission status
    }
    else {
      return permission;//if already user has given permission it just returns status
    }
  }

  getContacts() async {
    List<Contact> contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();//getting contacts and converting into list and each of type instance

    for (var i = 0; i < contacts.length; i++) {
      Contact contact = contacts[i];//for each iteration the contact will  holds a contact instance
      String first = '';//for first phonenumber
      String second = '';//for second phonenumber
      if (contact.phones.length > 0) {//checking the length of contact
        if (contact.phones.length > 1) {//if length of contacts greater than one it means it has two  phone number
          first = contact.phones
              .elementAt(0)
              .value.replaceAll(' ', '');//adding the first phone number to the variable first and removing whitespaces
          if(first.length==10)//if the length is equal to 10
              {
            first='+91'+first;//add +91 to  the string
          }
          second = contact.phones
              .elementAt(1)
              .value.replaceAll(' ', '');//simalr to first
          if(second.length==10)
          {
            second='+91'+second;
          }
          if (first == second && first.length>9) {//if both first and second are equal and we check the length of the number to remove unwanted numbers
            details.addAll({
              contact.displayName.replaceAll('_', ''): first,//adding daat to the map details
            });
          }
          else {//if first not equal to second
            if (first.length > 9)//check  length greater than 9
                {
              details.addAll({
                contact.displayName.replaceAll('_', ''): first,
              });
            }
            if(second.length>9)//check length greater than 9
                {
              details.addAll({
                contact.displayName.replaceAll('_', '') + '2': second,
              });
            }
          }
        }
        else {//it has a single phone number
          String first = contact.phones
              .elementAt(0)
              .value.replaceAll(' ', '');
          if(first.length==10)
          {
            first='+91'+first;
          }
          if(first.length>9) {
            details.addAll({
              contact.displayName.replaceAll('_', ''): first,
            });
          }
        }
      }
    }//closing of for loop
    int id = 1234;//user id
    Firestore firestore=Firestore.instance;//instance of firestore
    firestore.collection('contacts').document('$id').setData(
        {
          'numbers':details,
        }
    );//adding data to firestore
  }

  bool bag=false;//for construction of widget tree
  @override
  Widget build(BuildContext context) {
    var numbers=Map();//to get data from firestore
    var god=Map();//taking the first value and store it in god map
    List one=[];//for user name
    List two=[];//for user number
    List design=[];//to display green mark or invite
    return  Scaffold(
      body: ModalProgressHUD(//to dispaly the spinning wheel
        inAsyncCall: bag,
        child: Container(
            child: Center(
              child: RaisedButton(
                onPressed: (){
                  setState(() {
                    bag=true;
                  });
                  Firestore firestore=Firestore.instance;//instance of firestore
                  firestore.collection("contacts").document('567')
                      .get().then((value){//getting a specific document out from firestore
                    numbers=value.data;//storing the data in numbers
                    god=numbers['numbers'];//taking the value at numbers and storing it in god
                    details.forEach((k,v){//for every contact in user details
                      bool mark=true;//intializing a variable to true
                      god.forEach((m,n)//for every data from firestore user's list
                      {
                        if(v==n)//checking both values are same or not if same
                            {
                          one.add(k);//add  user name to one list
                          two.add(v);//add  user phonenumber to one list
                          design.add(true);////add  true  to one list
                          mark=false;//make the variable as false
                        }
                      });//end of inner for loop
                      if(mark)//check whether true or false
                          {
                        one.add(k);//add  user name to one list
                        two.add(v);//add  user phonenumber to one list
                        design.add(false);//add  true  to one list
                      }
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Display(one,two,design)), //pushing the name list,phone number list and check list to display page
                    );
                  });
                },
                child: Text('sync me'),
              ),
            )
        ),
      ),
    );
  }
}