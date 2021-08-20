///
/// Contains classes and interfaces needed by the widgets library which have no flutter
/// dependencies
///
library widgets_vm;


/// An item with a name and type
abstract class NamedItem {
  /// Return the name associated with this item
  String get name;

  /// Return the type of the item.
  String get type;
}