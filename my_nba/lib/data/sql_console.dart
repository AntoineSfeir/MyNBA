import 'package:sqflite/sqflite.dart';
import 'package:my_nba/data/database_service.dart';

class SqlConsole {
  Future<String> runQuery(String query) async {
    if (query.isNotEmpty) {
      final Database database = await DatabaseService().getDataBase();
      final result = await database.rawQuery(query);
      return _formatResult(result);
    }
    return 'Please enter a query.';
  }

  String _formatResult(List<Map<String, dynamic>> result) {
    if (result.isEmpty) {
      return 'No results found.';
    }

    // Extract column names
    List<String> columns = result.isNotEmpty ? result.first.keys.toList() : [];

    // Construct the formatted result string
    String formattedResult = '';

    // Add column headers
    formattedResult += '${columns.join('\t')}\n';

    // Add each row of data
    for (var row in result) {
      formattedResult += '${row.values.toList().join('\t')}\n';
    }

    return formattedResult;
  }
}
