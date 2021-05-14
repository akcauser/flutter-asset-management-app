class AssetType {
  final String name;
  AssetType({this.name});

  static getAssetTypes() {
    return ["Physical", "Digital", "Human"];
  }
}
