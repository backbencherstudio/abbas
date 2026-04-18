class AccountGetProfileModel {
  String? profileType;
  PersonalInfo? personalInfo;
  bool? hasActiveSubscription;
  SubscriptionPayment? subscriptionPayment;
  List<ContractDocuments>? contractDocuments;
  FeedbackCertificates? feedbackCertificates;

  AccountGetProfileModel({
    this.profileType,
    this.personalInfo,
    this.hasActiveSubscription,
    this.subscriptionPayment,
    this.contractDocuments,
    this.feedbackCertificates,
  });

  AccountGetProfileModel.fromJson(Map<String, dynamic> json) {
    profileType = json['profileType'];
    personalInfo = json['personalInfo'] != null
        ? PersonalInfo.fromJson(json['personalInfo'])
        : null;
    hasActiveSubscription = json['hasActiveSubscription'];
    subscriptionPayment = json['subscriptionPayment'] != null
        ? SubscriptionPayment.fromJson(json['subscriptionPayment'])
        : null;
    if (json['contractDocuments'] != null) {
      contractDocuments = <ContractDocuments>[];
      json['contractDocuments'].forEach((v) {
        contractDocuments!.add(ContractDocuments.fromJson(v));
      });
    }
    feedbackCertificates = json['feedbackCertificates'] != null
        ? FeedbackCertificates.fromJson(json['feedbackCertificates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['profileType'] = profileType;
    if (personalInfo != null) {
      data['personalInfo'] = personalInfo!.toJson();
    }
    data['hasActiveSubscription'] = hasActiveSubscription;
    if (subscriptionPayment != null) {
      data['subscriptionPayment'] = subscriptionPayment!.toJson();
    }
    if (contractDocuments != null) {
      data['contractDocuments'] = contractDocuments!
          .map((v) => v.toJson())
          .toList();
    }
    if (feedbackCertificates != null) {
      data['feedbackCertificates'] = feedbackCertificates!.toJson();
    }
    return data;
  }
}

class PersonalInfo {
  String? fullName;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? experienceLevel;
  String? avatar;
  String? actingGoals;

  PersonalInfo({
    this.fullName,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.experienceLevel,
    this.avatar,
    this.actingGoals,
  });

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    dateOfBirth = json['dateOfBirth'];
    experienceLevel = json['experienceLevel'];
    avatar = json['avatar'];
    actingGoals = json['actingGoals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['dateOfBirth'] = dateOfBirth;
    data['experienceLevel'] = experienceLevel;
    data['avatar'] = avatar;
    data['actingGoals'] = actingGoals;
    return data;
  }
}

class SubscriptionPayment {
  List<PaymentHistory>? paymentHistory;
  List<CurrentSubscriptions>? currentSubscriptions;

  SubscriptionPayment({this.paymentHistory, this.currentSubscriptions});

  SubscriptionPayment.fromJson(Map<String, dynamic> json) {
    if (json['paymentHistory'] != null) {
      paymentHistory = <PaymentHistory>[];
      json['paymentHistory'].forEach((v) {
        paymentHistory!.add(PaymentHistory.fromJson(v));
      });
    }
    if (json['currentSubscriptions'] != null) {
      currentSubscriptions = <CurrentSubscriptions>[];
      json['currentSubscriptions'].forEach((v) {
        currentSubscriptions!.add(CurrentSubscriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (paymentHistory != null) {
      data['paymentHistory'] = paymentHistory!.map((v) => v.toJson()).toList();
    }
    if (currentSubscriptions != null) {
      data['currentSubscriptions'] = currentSubscriptions!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PaymentHistory {
  String? id;
  String? amount;
  String? currency;
  String? paymentDate;
  String? status;
  String? course;

  PaymentHistory({
    this.id,
    this.amount,
    this.currency,
    this.paymentDate,
    this.status,
    this.course,
  });

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    currency = json['currency'];
    paymentDate = json['paymentDate'];
    status = json['status'];
    course = json['course'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['amount'] = amount;
    data['currency'] = currency;
    data['paymentDate'] = paymentDate;
    data['status'] = status;
    data['course'] = course;
    return data;
  }
}

class CurrentSubscriptions {
  String? course;
  String? status;
  bool? isPaymentCompleted;
  String? startDate;

  CurrentSubscriptions({
    this.course,
    this.status,
    this.isPaymentCompleted,
    this.startDate,
  });

  CurrentSubscriptions.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    status = json['status'];
    isPaymentCompleted = json['IsPaymentCompleted'];
    startDate = json['startDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['course'] = course;
    data['status'] = status;
    data['IsPaymentCompleted'] = isPaymentCompleted;
    data['startDate'] = startDate;
    return data;
  }
}

class ContractDocuments {
  String? course;
  dynamic enrolledDocuments;
  DigitalContract? digitalContract;
  RulesRegulations? rulesRegulations;

  ContractDocuments({
    this.course,
    this.enrolledDocuments,
    this.digitalContract,
    this.rulesRegulations,
  });

  ContractDocuments.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    enrolledDocuments = json['enrolled_documents'];
    digitalContract = json['digitalContract'] != null
        ? DigitalContract.fromJson(json['digitalContract'])
        : null;
    rulesRegulations = json['rulesRegulations'] != null
        ? RulesRegulations.fromJson(json['rulesRegulations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['course'] = course;
    data['enrolled_documents'] = enrolledDocuments;
    if (digitalContract != null) {
      data['digitalContract'] = digitalContract!.toJson();
    }
    if (rulesRegulations != null) {
      data['rulesRegulations'] = rulesRegulations!.toJson();
    }
    return data;
  }
}

class DigitalContract {
  String? id;
  String? enrollmentId;
  bool? agreed;
  DigitalSignature? digitalSignature;

  DigitalContract({
    this.id,
    this.enrollmentId,
    this.agreed,
    this.digitalSignature,
  });

  DigitalContract.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enrollmentId = json['enrollmentId'];
    agreed = json['agreed'];
    digitalSignature = json['digitalSignature'] != null
        ?  DigitalSignature.fromJson(json['digitalSignature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['enrollmentId'] = enrollmentId;
    data['agreed'] = agreed;
    if (digitalSignature != null) {
      data['digitalSignature'] = digitalSignature!.toJson();
    }
    return data;
  }
}

class DigitalSignature {
  String? id;
  String? fullName;
  String? signature;
  String? signedAt;
  String? digitalContractSigningId;
  dynamic rulesRegulationsSigningId;

  DigitalSignature({
    this.id,
    this.fullName,
    this.signature,
    this.signedAt,
    this.digitalContractSigningId,
    this.rulesRegulationsSigningId,
  });

  DigitalSignature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    signature = json['signature'];
    signedAt = json['signed_at'];
    digitalContractSigningId = json['digital_contract_signing_id'];
    rulesRegulationsSigningId = json['rules_regulations_signing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['full_name'] = fullName;
    data['signature'] = signature;
    data['signed_at'] = signedAt;
    data['digital_contract_signing_id'] = digitalContractSigningId;
    data['rules_regulations_signing_id'] = rulesRegulationsSigningId;
    return data;
  }
}

class RulesRegulations {
  String? id;
  String? enrollmentId;
  bool? accepted;
  DigitalSignature? digitalSignature;

  RulesRegulations({
    this.id,
    this.enrollmentId,
    this.accepted,
    this.digitalSignature,
  });

  RulesRegulations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enrollmentId = json['enrollmentId'];
    accepted = json['accepted'];
    digitalSignature = json['digitalSignature'] != null
        ?  DigitalSignature.fromJson(json['digitalSignature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['enrollmentId'] = enrollmentId;
    data['accepted'] = accepted;
    if (digitalSignature != null) {
      data['digitalSignature'] = digitalSignature!.toJson();
    }
    return data;
  }
}

class FeedbackCertificates {
  List<Feedback>? feedback;
  List<Certificates>? certificates;

  FeedbackCertificates({this.feedback, this.certificates});

  FeedbackCertificates.fromJson(Map<String, dynamic> json) {
    if (json['feedback'] != null) {
      feedback = <Feedback>[];
      json['feedback'].forEach((v) {
        feedback!.add(Feedback.fromJson(v));
      });
    }
    if (json['certificates'] != null) {
      certificates = <Certificates>[];
      json['certificates'].forEach((v) {
        certificates!.add( Certificates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (feedback != null) {
      data['feedback'] = feedback!.map((v) => v.toJson()).toList();
    }
    if (certificates != null) {
      data['certificates'] = certificates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedback {
  String? course;
  String? assignment;
  String? grade;
  String? feedback;
  String? gradedAt;

  Feedback({
    this.course,
    this.assignment,
    this.grade,
    this.feedback,
    this.gradedAt,
  });

  Feedback.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    assignment = json['assignment'];
    grade = json['grade'];
    feedback = json['feedback'];
    gradedAt = json['gradedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['course'] = course;
    data['assignment'] = assignment;
    data['grade'] = grade;
    data['feedback'] = feedback;
    data['gradedAt'] = gradedAt;
    return data;
  }
}

class Certificates {
  String? course;
  String? completionStatus;
  dynamic certificateUrl;

  Certificates({this.course, this.completionStatus, this.certificateUrl});

  Certificates.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    completionStatus = json['completionStatus'];
    certificateUrl = json['certificateUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['course'] = course;
    data['completionStatus'] = completionStatus;
    data['certificateUrl'] = certificateUrl;
    return data;
  }
}
