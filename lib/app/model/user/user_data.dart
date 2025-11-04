import 'package:json_annotation/json_annotation.dart';

import '../../utils/functions.dart';
part 'user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  @JsonKey(name: "mName", fromJson: Functions.asString)
  String? mName;
  @JsonKey(name: "mAddress", fromJson: Functions.asString)
  String? mAddress;
  @JsonKey(name: "mTel", fromJson: Functions.asString)
  String? mTel;
  @JsonKey(name: "mEmail", fromJson: Functions.asString)
  String? mEmail;
  @JsonKey(name: "mDepartment", fromJson: Functions.asString)
  String? mDepartment;
  @JsonKey(name: "mMobile_Phone", fromJson: Functions.asString)
  String? mMobilePhone;
  @JsonKey(name: "mRemarks", fromJson: Functions.asString)
  String? mRemarks;
  @JsonKey(name: "mFax", fromJson: Functions.asString)
  String? mFax;
  @JsonKey(name: "mPassword", fromJson: Functions.asString)
  String? mPassword;
  @JsonKey(name: "mUserGroup_Code", fromJson: Functions.asString)
  String? mUserGroupCode;
  @JsonKey(name: "mCode", fromJson: Functions.asString)
  String? mCode;
  @JsonKey(name: "T_User_ID", fromJson: Functions.asString)
  String? tUserId;
  @JsonKey(name: "mNon_Active", fromJson: Functions.asString)
  String? mNonActive;
  @JsonKey(name: "mMobile_prefix", fromJson: Functions.asString)
  String? mMobilePrefix;
  @JsonKey(name: "mobile", fromJson: Functions.asString, toJson: Functions.stringToPhoneNumber)
  String? mobile;

  UserData({
    this.mName,
    this.mAddress,
    this.mTel,
    this.mEmail,
    this.mDepartment,
    this.mMobilePhone,
    this.mRemarks,
    this.mFax,
    this.mPassword,
    this.mUserGroupCode,
    this.mCode,
    this.tUserId,
    this.mNonActive,
    this.mMobilePrefix,
    this.mobile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
