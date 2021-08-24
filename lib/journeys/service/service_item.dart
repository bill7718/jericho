import 'package:jericho/general/constants.dart';
import 'package:jericho/services/service_services.dart';
import 'package:jericho/widgets/widgets_vm.dart';
import 'package:waterloo/waterloo_vm.dart';

///
/// Represents the data associated with an item that is to be added to the service
///
class ServiceItem with Scored implements NamedItem, Clone<ServiceItem>, ServiceElement, YouTubeIdProvider {

  /// Holds the data for this item that is stored on the database
  final Map<String, dynamic> _data;

  List<List<SpanRange>> ranges = <List<SpanRange>>[];

  ServiceItem(this._data);

  @override
  String get name => _data['name'];

  @override
  String get type => _data['type'];

  Map<String, dynamic> get data =>_data;

  @override
  String get id =>_data[idFieldName];

  @override
  String get serviceItemRef=>'$type/$id:$name';

  @override
  clone() => ServiceItem(_data);

  @override
  int score(String filter) {
    var list = filter.split(' ');
    var response = 0;

    for (var item in list) {
      if (name.contains(item) || name.toLowerCase().contains(item)) {
        response = response + 100 * item.length * item.length;
      }
      var text = _data['text'] ?? '';
      if (text.contains(item)|| text.toLowerCase().contains(item)) {
        response = response + 10 * item.length * item.length;
      }
    }

    return response;
  }


  @override
  String get videoId => _data['videoId'];
}


abstract class YouTubeIdProvider  {

  String get videoId;
}

class SpanRange {
  final int start;
  final int end;

  SpanRange(this.start, this.end);

  @override
  String toString()=>'Start : $start End: $end';
}
