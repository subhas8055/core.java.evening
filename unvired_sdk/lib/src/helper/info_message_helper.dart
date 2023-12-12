import 'package:unvired_sdk/src/database/database_manager.dart';
import 'package:unvired_sdk/src/database/framework_database.dart';

class InfoMessageHelper {
  Future<List<InfoMessageData>> getAllInfoMessages() async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return await fwDb.allInfoMessages;
  }

  Future<InfoMessageData?> getInfoMessageByLid(String lid) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.getInfoMessage(lid));
  }

  Future<List<InfoMessageData?>> getInfoMessageByBeLid(String beLid) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.getInfoMessageByBeLid(beLid));
  }

  Future<List<InfoMessageData>> getInfoMessageByBeName(String beName) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.getInfoMessageByBeName(beName));
  }

  Future<int> deleteInfoMessageByLid(String lid) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.deleteInfoMessageByLid(lid));
  }

  Future<int> deleteInfoMessageByBeLid(String beLid) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.deleteInfoMessageByBeLid(beLid));
  }

  Future<int> deleteInfoMessageByBeName(String beName) async {
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.deleteInfoMessageByBeName(beName));
  }

  Future<int> deleteAllInfoMessages()async{
    FrameworkDatabase fwDb = await DatabaseManager().getFrameworkDB();
    return (await fwDb.deleteAllInfoMessages());
  }

}
