enum IS_HAVE { leader, member }

class ProjectObject {
  final String projectName;
  final List<dynamic> tasklist;
  final IS_HAVE userCode;
  final int projectId;

  ProjectObject(this.projectName, this.tasklist, this.userCode, this.projectId);

  factory ProjectObject.fromJson(Map<String, dynamic> json) {
    return ProjectObject(
      json['projectName'],
      json['tasklist'],
      (json['userCode'] as String) == 'p_leader'
          ? IS_HAVE.leader
          : IS_HAVE.member,
      json['projectId'],
    );
  }
}
