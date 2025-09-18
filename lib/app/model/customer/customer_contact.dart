import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';

part 'customer_contact.g.dart';

@JsonSerializable()
class CustomerContact {
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mDepartment", fromJson: Functions.asString)
  String? mDepartment;
  @JsonKey(name: "mEmail", fromJson: Functions.asString)
  String? mEmail;
  @JsonKey(name: "mFax", fromJson: Functions.asString)
  String? mFax;
  @JsonKey(name: "mMobile_Phone", fromJson: Functions.asString)
  String? mMobilePhone;
  @JsonKey(name: "mTel", fromJson: Functions.asString)
  String? mTel;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mName", fromJson: Functions.asString)
  String? mName;
  @JsonKey(name: "mItem", fromJson: Functions.asString)
  String? mItem;
  @JsonKey(name: "T_Customer_ID", fromJson: Functions.asString)
  String? tCustomerId;
  @JsonKey(name: "default", fromJson: Functions.asString)
  String? customerContactDefault;

  CustomerContact({
    this.mAddress,
    this.mDepartment,
    this.mEmail,
    this.mFax,
    this.mMobilePhone,
    this.mTel,
    this.mRemarks,
    this.mName,
    this.mItem,
    this.tCustomerId,
    this.customerContactDefault,
  });

  CustomerContact copyWith({
    String? mAddress,
    String? mDepartment,
    String? mEmail,
    String? mFax,
    String? mMobilePhone,
    String? mTel,
    String? mRemarks,
    String? mName,
    String? mItem,
    String? tCustomerId,
    String? customerContactDefault,
  }) => CustomerContact(
    mAddress: mAddress ?? this.mAddress,
    mDepartment: mDepartment ?? this.mDepartment,
    mEmail: mEmail ?? this.mEmail,
    mFax: mFax ?? this.mFax,
    mMobilePhone: mMobilePhone ?? this.mMobilePhone,
    mTel: mTel ?? this.mTel,
    mRemarks: mRemarks ?? this.mRemarks,
    mName: mName ?? this.mName,
    mItem: mItem ?? this.mItem,
    tCustomerId: tCustomerId ?? this.tCustomerId,
    customerContactDefault: customerContactDefault ?? this.customerContactDefault,
  );

  factory CustomerContact.fromJson(Map<String, dynamic> json) => _$CustomerContactFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerContactToJson(this);

  void updateFromSource(CustomerContact contact) {
    if (contact.mAddress != null) mAddress = contact.mAddress;
    if (contact.mDepartment != null) mDepartment = contact.mDepartment;
    if (contact.mEmail != null) mEmail = contact.mEmail;
    if (contact.mFax != null) mFax = contact.mFax;
    if (contact.mMobilePhone != null) mMobilePhone = contact.mMobilePhone;
    if (contact.mTel != null) mTel = contact.mTel;
    if (contact.mRemarks != null) mRemarks = contact.mRemarks;
    if (contact.mName != null) mName = contact.mName;
    if (contact.mItem != null) mItem = contact.mItem;
    if (contact.tCustomerId != null) tCustomerId = contact.tCustomerId;
    if (contact.customerContactDefault != null) customerContactDefault = contact.customerContactDefault;
  }
}
