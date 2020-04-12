class Covid {
  final int deaths;
  final String state;
  final String colorVal;
  Covid(this.deaths,this.state,this.colorVal);

  Covid.fromMap(Map<String, dynamic> map)
      : assert(map['deaths'] != null),
        assert(map['state'] != null),
        assert(map['colorVal'] != null),
        deaths = map['deaths'],
        state = map['state'],
        colorVal=map['colorVal'];

  @override
  String toString() => "Record<$deaths:$state>";
}