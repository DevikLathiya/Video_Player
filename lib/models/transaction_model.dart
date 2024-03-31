class TransactionModel {
  TransactionModel({
      this.userTransactions,});

  TransactionModel.fromJson(dynamic json) {
    if (json['user_transactions'] != null) {
      userTransactions = [];
      json['user_transactions'].forEach((v) {
        userTransactions?.add(UserTransactions.fromJson(v));
      });
    }
  }
  List<UserTransactions>? userTransactions;
TransactionModel copyWith({  List<UserTransactions>? userTransactions,
}) => TransactionModel(  userTransactions: userTransactions ?? this.userTransactions,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userTransactions != null) {
      map['user_transactions'] = userTransactions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
class UserTransactions {
  int? id;
  String? orderId;
  int? userId;
  String? uname;
  int? financeId;
  String? financeName;
  int? coins;
  int? amount;
  int? status;
  String? transactionId;
  String? createdAt;
  String? updatedAt;
  String? paymentStatus;
  String? remarks;

  UserTransactions(
      {this.id,
        this.orderId,
        this.userId,
        this.uname,
        this.financeId,
        this.financeName,
        this.coins,
        this.amount,
        this.status,
        this.transactionId,
        this.createdAt,
        this.updatedAt,
        this.paymentStatus,
        this.remarks});

  UserTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    uname = json['uname'];
    financeId = json['finance_id'];
    financeName = json['finance_name'];
    coins = json['coins'];
    amount = json['amount'];
    status = json['status'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentStatus = json['payment_status'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['uname'] = this.uname;
    data['finance_id'] = this.financeId;
    data['finance_name'] = this.financeName;
    data['coins'] = this.coins;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['transaction_id'] = this.transactionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['payment_status'] = this.paymentStatus;
    data['remarks'] = this.remarks;
    return data;
  }
}