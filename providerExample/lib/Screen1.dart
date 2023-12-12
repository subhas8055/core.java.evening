import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerexample/example.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int result=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Provider Example'),
          centerTitle: true,
        ),
        body:Consumer<ProExample>(
          builder: (context, value, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('Result : ',style: TextStyle(fontSize: 30,),),
                  Text((value.num>=0) ?'${value.num}' :'0' ,style: TextStyle(fontSize: 30,color: (value.num <= 10) ?Colors.greenAccent : Colors.redAccent),),

                  ElevatedButton(onPressed: (){
                    Provider.of<ProExample>(context,listen: false).add();
                    // result++;
                    // setState(() {
                    //
                    // });
                  }, child: Text('add')),
                  ElevatedButton(onPressed: (){
                    Provider.of<ProExample>(context,listen: false).substract();
                    // result--;
                    // setState(() {
                    //
                    // });
                  }, child: Text('substract')),
                ],
              ),
            );
          },
        )

      ),
    ) ;
  }
}
/*
return MaterialApp(
home: Scaffold(

body: Center(
child: Column(
children: <Widget>[
// Using Consumer to listen to Counter changes and rebuild UI
Consumer<Counter>(
builder: (context, counter, child) => Text(
'Count: ${counter.count}',
style: TextStyle(fontSize: 24),
),
),
SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: <Widget>[
// Using Provider.of to directly access the Counter instance
ElevatedButton(
onPressed: () =>
Provider.of<Counter>(context, listen: false)
    .increment(),
child: Text('Increment'),
),
ElevatedButton(
onPressed: () =>
Provider.of<Counter>(context, listen: false)
    .decrement(),
child: Text('Decrement'),
),
],
),
],
),
),
),
);

 */
