import 'package:cloud_firestore/cloud_firestore.dart';

class IssueModel {
  String id;
  String subject;
  String describe;
  Timestamp updatedAt;
  Timestamp createdAt;

  IssueModel(
      {this.id, this.subject, this.describe, this.updatedAt, this.createdAt});

  IssueModel.fromData(Map<String, dynamic> data, {String id})
      : id = id,
        subject = data['subject'],
        describe = data['describe'],
        updatedAt = data['updatedAt'],
        createdAt = data['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'describe': describe,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  IssueModel copyWith({
    String id,
    String subject,
    String describe,
    Timestamp dateVisited,
    Timestamp createdAt,
  }) {
    return IssueModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      describe: describe ?? this.describe,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
