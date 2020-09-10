import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Display extends StatelessWidget {

  final List a,b,c;//a ,b,c for username,phone and true/false value
  Display(this.a,this.b,this.c);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: a.length,
          itemBuilder: (context,i){
         String phone=b[i];//taking the phonenumber value and storing it in string phone
          return ListTile(
            title: Text(a[i]),
            subtitle:Text(b[i]) ,
            trailing: c[i]?//based on the value of c[i]
            Icon(Icons.check,color: Colors.green,):
            FlatButton(
              child: Text('invite'),
              onPressed: ()async{
               String url = 'sms:+$phone?body=message';
                await launch(url);//calling the the function to invite
                print('hi');
                }
            ),
          );
      })
    );
  }
}


