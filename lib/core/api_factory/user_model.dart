import 'dart:math';

import 'package:get/get.dart';

class UserModel {
  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.mobile,
    this.emailVerifiedAt,
    this.wallet,
    this.earning,
    this.status,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.kyc,
    this.userFavourites,
    this.userEarnings,
    this.userKyc,
    this.gender,
    this.location,
    this.dob,
    this.meg_user,
    this.amount,
  });


  @override
  String toString() {
    return 'UserModel{amount:$amount,id: $id, firstname: $firstname, lastname: $lastname, email: $email, mobile: $mobile,  emailVerifiedAt: $emailVerifiedAt, wallet: $wallet, gender: $gender, location: $location, dob: $dob, earning: $earning, status: $status, isDelete: $isDelete, createdAt: $createdAt, updatedAt: $updatedAt, kyc: $kyc, userFavourites: $userFavourites, userEarnings: $userEarnings, userKyc: $userKyc, meg_user: $meg_user}';
  }

  UserModel.fromJson(dynamic json) {
    print("UserModel ==> $json");
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'];
    wallet = json['wallet'];
    earning = json['earning'];
    status = json['status'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    kyc = json['KYC'];
    gender = json['gender'];
    location = json['location'];
    dob = json['dob'];
    meg_user = json['meg_user'];
    amount = json['amount'];
    // if (json['user_favourites'] != null) {
    //   userFavourites = [];
    //   json['user_favourites'].forEach((v) {
    //     userFavourites?.add(Dynamic.fromJson(v));
    //   });
    // }
    // if (json['user_earnings'] != null) {
    //   userEarnings = [];
    //   json['user_earnings'].forEach((v) {
    //     userEarnings?.add(Dynamic.fromJson(v));
    //   });
    // }
    userKyc = json['user_kyc'] != null ? UserKyc.fromJson(json['user_kyc']) : null;
  }
  num? id;
  String? firstname;
  String? lastname;
  String? email;
  String? mobile;
  String? amount;
  dynamic emailVerifiedAt;
  num? wallet;
  String? gender;
  String? location;
  String? dob;
  num? earning;
  num? status;
  num? isDelete;
  String? createdAt;
  String? updatedAt;
  bool? kyc;
  List<dynamic>? userFavourites;
  List<dynamic>? userEarnings;
  UserKyc? userKyc;
  int? meg_user;

  UserModel copyWith({  num? id,
    String? firstname,
    String? lastname,
    String? email,
    String? amount,
    String? mobile,
    dynamic emailVerifiedAt,
    num? wallet,
    num? earning,
    num? status,
    num? isDelete,
    String? createdAt,
    String? updatedAt,
    bool? kyc,
    List<dynamic>? userFavourites,
    List<dynamic>? userEarnings,
    UserKyc? userKyc,
    int? meg_user,
  }) => UserModel(  id: id ?? this.id,
    firstname: firstname ?? this.firstname,
    lastname:  lastname?? this.lastname,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    wallet: wallet ?? this.wallet,
    earning: earning ?? this.earning,
    status: status ?? this.status,
    isDelete: isDelete ?? this.isDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    kyc: kyc ?? this.kyc,
    userFavourites: userFavourites ?? this.userFavourites,
    userEarnings: userEarnings ?? this.userEarnings,
    userKyc: userKyc ?? this.userKyc,
    amount: amount ?? this.amount,
    meg_user: meg_user ?? this.meg_user,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['email'] = email;
    map['mobile'] = mobile;
    map['email_verified_at'] = emailVerifiedAt;
    map['wallet'] = wallet;
    map['earning'] = earning;
    map['status'] = status;
    map['is_delete'] = isDelete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['KYC'] = kyc;
    map['amount'] = amount;
    map['gender'] = gender;
    map['location'] = location;
    map['dob'] = dob;
    map['meg_user'] = meg_user;
    if (userFavourites != null) {
      map['user_favourites'] = userFavourites?.map((v) => v.toJson()).toList();
    }
    if (userEarnings != null) {
      map['user_earnings'] = userEarnings?.map((v) => v.toJson()).toList();
    }
    if (userKyc != null) {
      map['user_kyc'] = userKyc?.toJson();
    }
    return map;
  }

}

class UserKyc {
  UserKyc({
    this.id,
    this.userId,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankStatement,
    this.photo,
    this.aadhaarNumber,
    this.voterId,
    this.panNumber,
    this.status,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.kycdropdown,
    this.reason,
  });

  UserKyc.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    bankAccountNumber = json['bank_account_number'];
    ifscCode = json['ifsc_code'];
    bankStatement = json['bank_statement'];
    photo = json['photo'];
    aadhaarNumber = json['aadhaar_number'];
    voterId = json['voter_id'];
    panNumber = json['pan_number'];
    status = json['status'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reason = json['reason'];
    kycdropdown = json['kycdropdown'];
  }
  num? id;
  num? userId;
  String? bankAccountNumber;
  String? ifscCode;
  String? bankStatement;
  String? photo;
  String? aadhaarNumber;
  String? voterId;
  String? panNumber;
  num? status;
  num? isDelete;
  String? createdAt;
  String? updatedAt;
  String? kycdropdown;
  String? reason;

  UserKyc copyWith({  num? id,
    num? userId,
    String? bankAccountNumber,
    String? ifscCode,
    String? bankStatement,
    String? photo,
    String? aadhaarNumber,
    String? voterId,
    String? panNumber,
    num? status,
    num? isDelete,
    String? createdAt,
    String? updatedAt,
    String? kycdropdown,
    String? reason
  }) => UserKyc(  id: id ?? this.id,
    userId: userId ?? this.userId,
    bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
    ifscCode: ifscCode ?? this.ifscCode,
    bankStatement: bankStatement ?? this.bankStatement,
    photo: photo ?? this.photo,
    aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
    voterId: voterId ?? this.voterId,
    panNumber: panNumber ?? this.panNumber,
    status: status ?? this.status,
    isDelete: isDelete ?? this.isDelete,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    kycdropdown: kycdropdown ?? this.kycdropdown,
    reason: reason ?? this.reason,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['bank_account_number'] = bankAccountNumber;
    map['ifsc_code'] = ifscCode;
    map['bank_statement'] = bankStatement;
    map['photo'] = photo;
    map['aadhaar_number'] = aadhaarNumber;
    map['voter_id'] = voterId;
    map['pan_number'] = panNumber;
    map['status'] = status;
    map['is_delete'] = isDelete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['reason'] = reason;
    map['kycdropdown'] = kycdropdown;
    return map;
  }

  @override
  String toString() {
    return 'UserKyc{id: $id, userId: $userId, bankAccountNumber: $bankAccountNumber, ifscCode: $ifscCode, bankStatement: $bankStatement, photo: $photo, aadhaarNumber: $aadhaarNumber, voterId: $voterId, panNumber: $panNumber, status: $status, isDelete: $isDelete, createdAt: $createdAt, updatedAt: $updatedAt, kycdropdown: $kycdropdown, reason: $reason}';
  }
}