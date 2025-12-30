// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  status: (json['status'] as num?)?.toInt(),
  msg: json['msg'] as String?,
  apiResult: json['apiResult'] == null
      ? null
      : LoginResult.fromJson(json['apiResult'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'apiResult': instance.apiResult?.toJson(),
    };

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
  company: json['company'] as String?,
  pwd: json['pwd'] as String?,
  user: json['user'] as String?,
  dsn: json['dsn'] == null
      ? null
      : Dsn.fromJson(json['dsn'] as Map<String, dynamic>),
  aesKey: json['aesKey'] as String,
);

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) =>
    <String, dynamic>{
      'company': instance.company,
      'pwd': instance.pwd,
      'user': instance.user,
      'dsn': instance.dsn?.toJson(),
      'aesKey': instance.aesKey,
    };

Dsn _$DsnFromJson(Map<String, dynamic> json) => Dsn(
  type: json['type'] as String?,
  hostname: json['hostname'] as String?,
  database: json['database'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
  hostport: (json['hostport'] as num?)?.toInt(),
  charset: json['charset'] as String?,
  prefix: json['prefix'] as String?,
);

Map<String, dynamic> _$DsnToJson(Dsn instance) => <String, dynamic>{
  'type': instance.type,
  'hostname': instance.hostname,
  'database': instance.database,
  'username': instance.username,
  'password': instance.password,
  'hostport': instance.hostport,
  'charset': instance.charset,
  'prefix': instance.prefix,
};
