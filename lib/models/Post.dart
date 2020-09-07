class Post {
  final int no;
  final String sub;
  final String com;
  final int time;
  final int replies;
  final int images;
  final List<String> files;
  final List<String> thumbs;
  final List<int> reply_to;
  bool op;
  List<int> replies_nos;

  Post(this.no, this.sub, this.com, this.time, this.replies,
    this.images, this.files, this.thumbs, this.reply_to);

  List<int> get replyTo {
    return this.reply_to;
  }

  bool get isOp {
    return this.op;
  }

  void set isOp(bool _isOp) {
    this.op = _isOp;
  }

  List<int> get repliesNos {
    return this.replies_nos;
  }

  void set repliesNos(List<int> _repliesNos) {
    this.replies_nos = _repliesNos;
  }

  factory Post.fromJson(Map<String, dynamic> json){
    var replies_num = 0;
    var images_num = 0;
    if(json.containsKey('replies')){
      replies_num = json['replies'];
      images_num = json['omitted_images'] + json['images'];
    }
    var tim = json['tim'];
    var ext = json['ext'];
    List<String> files = List<String>();
    List<String> thumbs = List<String>();
    if (tim != null) {
      var thumb_ext = json['ext'];
      if(json['ext'] == '.mp4' || json['ext'] == '.webm'){
        thumb_ext = '.jpg';
      }
      files.add('https://55chan.org/b/src/$tim$ext');
      thumbs.add('https://55chan.org/b/thumb/$tim${thumb_ext}');
    }
    if(json.containsKey('embed')) {
      RegExp regExp = new RegExp(
        r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)',
        caseSensitive: false,
        multiLine: false,
      );
      if(regExp.hasMatch(json['embed'])) {
        files.add(regExp.stringMatch(json['embed']).toString());
        thumbs.add('https://img.youtube.com/vi/${regExp.firstMatch(json['embed']).group(5)}/hqdefault.jpg');
      }
    }
    if(json.containsKey('extra_files')){
      json['extra_files'].forEach((file) {
        var thumb_ext = file['ext'];
        if(file['ext'] == '.mp4' || file['ext'] == '.webm'){
          thumb_ext = '.jpg';
        }
        files.add('https://55chan.org/b/src/${file['tim']}${file['ext']}');
        thumbs.add('https://55chan.org/b/thumb/${file['tim']}${thumb_ext}');
      });
    }

    var reps = List<int>();
    var regExp = RegExp(r"highlightReply\(\'([0-9]+)\'");
    if(json['com'] != null && !json['com'].isEmpty) {
      var matches = regExp.allMatches(json['com']);
      for (var match in matches) {
        var match_str = match.group(1);
        reps.add(int.parse(match_str));
      }
    }

    return Post(
      json['no'],
      json['sub'],
      json['com'],
      json['time'],
      replies_num,
      images_num,
      files,
      thumbs,
      reps
    );
  }

  Map<String, dynamic> toJson() => {
    'no': no,
    'sub': sub,
    'com': com,
    'time': time,
    'replies': replies,
    'images': images,
    'files': files
  };
}

