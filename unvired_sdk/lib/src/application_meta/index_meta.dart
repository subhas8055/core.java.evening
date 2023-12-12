class IndexMeta {
  late String _indexName;
  late String _description;
  late String _structureName;
  late List<String> _fieldNames;

  String getIndexName() {
    return _indexName;
  }

  void setIndexName(String indexName) {
    _indexName = indexName;
  }

  String getDescription() {
    return _description;
  }

  void setDescription(String description) {
    _description = description;
  }

  String getStructureName() {
    return _structureName;
  }

  void setStructureName(String structureName) {
    _structureName = structureName;
  }

  List<String> getFieldName() {
    return _fieldNames;
  }

  void setFieldName(List<String> fieldNames) {
    _fieldNames = fieldNames;
  }
}
