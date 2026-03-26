class TaTData {
  List<Data>? data;
  Query? query;
  Pagination? pagination;

  TaTData({this.data, this.query, this.pagination});

  TaTData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  String? status;
  dynamic placeId;
  String? name;
  String? introduction;
  SimpleCategory? category;
  Sha? sha;
  dynamic latitude;
  dynamic longitude;
  Location? location;
  List<String>? thumbnailUrl;
  List<String>? tags;
  dynamic distance;
  String? createdAt;
  String? updatedAt;

  Data({
    this.status,
    this.placeId,
    this.name,
    this.introduction,
    this.category,
    this.sha,
    this.latitude,
    this.longitude,
    this.location,
    this.thumbnailUrl,
    this.tags,
    this.distance,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    placeId = json['placeId']; // ไม่ต้อง cast แค่รับมาตรงๆ
    name = json['name'];
    introduction = json['introduction'];
    category =
        json['category'] != null
            ? SimpleCategory.fromJson(json['category'])
            : null;
    sha = json['sha'] != null ? Sha.fromJson(json['sha']) : null;
    latitude = json['latitude']; // ไม่ต้อง cast
    longitude = json['longitude']; // ไม่ต้อง cast
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;

    // Safe parsing สำหรับ thumbnailUrl
    if (json['thumbnailUrl'] != null && json['thumbnailUrl'] is List) {
      thumbnailUrl =
          (json['thumbnailUrl'] as List).map((e) => e.toString()).toList();
    } else {
      thumbnailUrl = [];
    }

    // Safe parsing สำหรับ tags
    if (json['tags'] != null && json['tags'] is List) {
      tags = (json['tags'] as List).map((e) => e.toString()).toList();
    } else {
      tags = [];
    }

    distance = json['distance']; // ไม่ต้อง cast
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['placeId'] = this.placeId;
    data['name'] = this.name;
    data['introduction'] = this.introduction;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.sha != null) {
      data['sha'] = this.sha!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['tags'] = this.tags;
    data['distance'] = this.distance;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class SimpleCategory {
  int? categoryId;
  String? name;

  SimpleCategory({this.categoryId, this.name});

  SimpleCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    return data;
  }
}

class Sha {
  String? name;
  String? detail;
  String? thumbnailUrl;
  Type? type;
  Category? category;

  Sha({this.name, this.detail, this.thumbnailUrl, this.type, this.category});

  Sha.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    detail = json['detail'];
    thumbnailUrl = json['thumbnailUrl'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    category =
        json['category'] != null
            ? new Category.fromJson(json['category'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Type {
  int? typeId;
  String? name;

  Type({this.typeId, this.name});

  Type.fromJson(Map<String, dynamic> json) {
    typeId = json['typeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeId'] = this.typeId;
    data['name'] = this.name;
    return data;
  }
}

class Category {
  int? categoryId;
  String? name;
  String? icon;

  Category({this.categoryId, this.name, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}

class Location {
  String? address;
  Province? province;
  District? district;
  SubDistrict? subDistrict;
  String? postcode;

  Location({
    this.address,
    this.province,
    this.district,
    this.subDistrict,
    this.postcode,
  });

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    province =
        json['province'] != null
            ? new Province.fromJson(json['province'])
            : null;
    district =
        json['district'] != null
            ? new District.fromJson(json['district'])
            : null;
    subDistrict =
        json['subDistrict'] != null
            ? new SubDistrict.fromJson(json['subDistrict'])
            : null;
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    if (this.province != null) {
      data['province'] = this.province!.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    if (this.subDistrict != null) {
      data['subDistrict'] = this.subDistrict!.toJson();
    }
    data['postcode'] = this.postcode;
    return data;
  }
}

class Province {
  int? provinceId;
  String? name;

  Province({this.provinceId, this.name});

  Province.fromJson(Map<String, dynamic> json) {
    provinceId = json['provinceId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provinceId'] = this.provinceId;
    data['name'] = this.name;
    return data;
  }
}

class District {
  int? districtId;
  String? name;

  District({this.districtId, this.name});

  District.fromJson(Map<String, dynamic> json) {
    districtId = json['districtId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['name'] = this.name;
    return data;
  }
}

class SubDistrict {
  int? subDistrictId;
  String? name;

  SubDistrict({this.subDistrictId, this.name});

  SubDistrict.fromJson(Map<String, dynamic> json) {
    subDistrictId = json['subDistrictId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subDistrictId'] = this.subDistrictId;
    data['name'] = this.name;
    return data;
  }
}

class Query {
  List<int>? ids;
  String? keyword;
  String? type;
  int? provinceId;
  bool? shaFlag;
  int? shaTypeId;
  String? categoryCode;
  int? categoryId;
  bool? hasIntroduction;
  bool? hasName;
  bool? hasThumbnail;
  int? latitude;
  int? longitude;
  int? radius;
  int? limit;
  int? page;
  String? semantic;
  String? updatedAt;

  Query({
    this.ids,
    this.keyword,
    this.type,
    this.provinceId,
    this.shaFlag,
    this.shaTypeId,
    this.categoryCode,
    this.categoryId,
    this.hasIntroduction,
    this.hasName,
    this.hasThumbnail,
    this.latitude,
    this.longitude,
    this.radius,
    this.limit,
    this.page,
    this.semantic,
    this.updatedAt,
  });

  Query.fromJson(Map<String, dynamic> json) {
    try {
      // Safe parsing for ids list
      if (json['ids'] != null && json['ids'] is List) {
        ids =
            (json['ids'] as List)
                .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
                .toList();
      }

      keyword = json['keyword']?.toString();
      type = json['type']?.toString();
      provinceId =
          json['provinceId'] is String
              ? int.tryParse(json['provinceId'])
              : json['provinceId'];
      shaFlag = json['shaFlag'];
      shaTypeId =
          json['shaTypeId'] is String
              ? int.tryParse(json['shaTypeId'])
              : json['shaTypeId'];
      categoryCode = json['categoryCode']?.toString();
      categoryId =
          json['categoryId'] is String
              ? int.tryParse(json['categoryId'])
              : json['categoryId'];
      hasIntroduction = json['hasIntroduction'];
      hasName = json['hasName'];
      hasThumbnail = json['hasThumbnail'];
      latitude =
          json['latitude'] is String
              ? int.tryParse(json['latitude'])
              : json['latitude'];
      longitude =
          json['longitude'] is String
              ? int.tryParse(json['longitude'])
              : json['longitude'];
      radius =
          json['radius'] is String
              ? int.tryParse(json['radius'])
              : json['radius'];
      limit =
          json['limit'] is String ? int.tryParse(json['limit']) : json['limit'];
      page = json['page'] is String ? int.tryParse(json['page']) : json['page'];
      semantic = json['semantic']?.toString();
      updatedAt = json['updatedAt']?.toString();
    } catch (e) {
      print('❌ Error parsing Query: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ids'] = this.ids;
    data['keyword'] = this.keyword;
    data['type'] = this.type;
    data['provinceId'] = this.provinceId;
    data['shaFlag'] = this.shaFlag;
    data['shaTypeId'] = this.shaTypeId;
    data['categoryCode'] = this.categoryCode;
    data['categoryId'] = this.categoryId;
    data['hasIntroduction'] = this.hasIntroduction;
    data['hasName'] = this.hasName;
    data['hasThumbnail'] = this.hasThumbnail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['limit'] = this.limit;
    data['page'] = this.page;
    data['semantic'] = this.semantic;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? total;
  int? totalPage;

  Pagination({this.pageNumber, this.pageSize, this.total, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['totalPage'] = this.totalPage;
    return data;
  }
}
