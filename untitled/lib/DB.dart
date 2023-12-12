import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Dto.dart';

class DbHelper{
  late Database db;

  Future<Database> createDb() async {
    String path = await getDatabasesPath();

      join(path,"manDb.db");
       var db = await openDatabase(path,version: 1,onCreate:createTable() );
       return  db;

  }
  createTable()async{
    if(db != null) {
      return await db.execute(
          "create table man(email Text primary key,name Text,city Text,password Text)");
    }else{
        createDb();
    }
  }
 save(Dto dto)async{
    if(db != null && dto != null){
await db.rawInsert("Insert into man values(${dto.name},${dto.email},${dto.password},${dto.city},)");
return db;
    }
 }

 getAll()async{
    if(db != null){
      return await db.rawQuery("select * from  man");
    }
 }

 getByEmail(String email,String password)async{
    if(db != null){
      return await db.rawQuery("select * from  man where email=$email and password=$password");
    }
 }

 update(Dto dto)async{
    if(db != null){
      await db.rawUpdate("update man set name=${dto.name},city=${dto.city} where email=${dto.email}");
    }
 }

  updatePassword(String email,String newPassword,String oldPassword)async{
    if(db != null){
      await db.rawUpdate("update man set password=$newPassword  where email=$email and password=$oldPassword");
    }
  }
 delete(String email)async{
    if(db != null){
    return await db.rawDelete("delete from man where email=$email");
    }
    else{
      createDb();
    }
 }
 _getUpto(int num)async{
    if(db != null){
     return  await db.rawQuery("select * from man where id <= num");
    }
 }

 _getLikeEmail(String nam)async{
    if(db != null){
      return await db.rawQuery("select * from man where email like '%n$nam%'");
    }
 }
  _getLikeName(String nam)async{
    if(db != null){
      return await db.rawQuery("select * from man where name like '%n$nam%'");
    }
  }
  _getLikeCity(String nam)async{
    if(db != null){
      return await db.rawQuery("select * from man where city like '%n$nam%'");
    }
  }
  _updateByName(String name,String city)async{
    if(db != null){
      return await db.rawUpdate("update man set city =$city where name =$name ");
    }
  }
   getByEmail1(String email)async {
     if(db != null){
       return await db.rawQuery("select * from  man where email=$email ");
     }
  }

  updateByEmail1(String email,String newPassword)async{
    if(db != null){
      return await db.rawUpdate("update man set password=$newPassword where email=$email");
    }
  }
}
