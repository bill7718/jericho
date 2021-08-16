import 'package:jericho/journeys/service/service.dart';
import 'package:jericho/widgets/drop_target_list_view.dart';
import 'package:jericho/widgets/filtered_list.dart';

class ServiceItem with Scored implements NamedItem, Clone<ServiceItem> {
  final Map<String, dynamic> _data;

  ServiceItem(this._data);

  @override
  String get name => _data['name'];

  @override
  String get type => _data['type'];

  @override
  clone() => ServiceItem(_data);

  @override
  int score(String filter) {
    var list = filter.split(' ');
    var response = 0;

    for (var item in list) {
      if (name.contains(item)) {
        response = response + 100 * item.length * item.length;
      }
      var text = _data['text'] ?? '';
      if (text.contains(item)) {
        response = response + 10 * item.length * item.length;
      }
    }

    return response;
  }
}
