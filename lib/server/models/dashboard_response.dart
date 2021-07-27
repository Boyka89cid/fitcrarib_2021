import 'package:fitcarib/base/model/base_model.dart';

class DashboardResponse extends BaseModel {
  int profile_score = 0;
  late String phonebook_updated_at;
  late ProfileComplete profileComplete;
  int new_postings = 0;
  int old_postings = 0;

  DashboardResponse.fromJSON(data) : super.fromJSON(data) {
    if (!(data is String)) {
      if (data['profile_score'] == 0)
        profile_score = 0;
      else
        profile_score = data['profile_score'];
      profileComplete = ProfileComplete.fromJSON(data['profile_complete']);
      new_postings = data['new_postings'];
      old_postings = data['old_postings'];
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map["profile_score"] = profile_score;
    map["new_postings"] = new_postings;
    map["old_postings"] = old_postings;
    map["profile_complete"] = profileComplete.toMap();
    return map;
  }
}

class ProfileComplete extends BaseModel {
  bool photograph = false;
  bool industry = false;
  bool skills = false;
  bool educations = false;
  bool experiences = false;
  bool resumes = false;

  ProfileComplete.fromJSON(data) : super.fromJSON(data) {
    if (!(data is String)) {
      photograph = data['photograph'];
      industry = data['industry'];
      skills = data['skills'];
      educations = data['educations'];
      experiences = data['experiences'];
      resumes = data['resumes'];
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map["photograph"] = photograph;
    map["industry"] = industry;
    map["skills"] = skills;
    map["educations"] = educations;
    map["experiences"] = experiences;
    map["resumes"] = resumes;
    return map;
  }
}
