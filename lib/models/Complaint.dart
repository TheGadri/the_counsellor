
class Complaint {

  String subject;
  String message;
  String priority;
  String createdAt;
  String status;

	Complaint.fromJsonMap(Map<String, dynamic> map): 
		subject = map["subject"],
		message = map["message"],
		priority = map["priority"],
		createdAt = map["createdAt"],
		status = map["status"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['subject'] = subject;
		data['message'] = message;
		data['priority'] = priority;
		data['createdAt'] = createdAt;
		data['status'] = status;
		return data;
	}
}
