class detail_place {
  dynamic placeId;
  Status? status;
  String? name;
  Category? category;
  Information? information;
  Sha? sha;
  dynamic latitude;
  dynamic longitude;
  Location? location;
  Contact? contact;
  Company? company;
  List<Branches>? branches;
  String? logoUrl;
  String? thumbnailUrl;
  List<String>? desktopImageUrls;
  List<String>? mobileImageUrls;
  dynamic hitScore;
  List<String>? tags;
  String? googleMapUrl;
  dynamic distance;
  String? createdAt;
  String? updatedAt;
  List<Awards>? awards;
  dynamic minPrice;
  dynamic maxPrice;
  String? specialCloseText;
  List<OpeningHours>? openingHours;
  List<Facilities>? facilities;
  List<String>? services;
  List<String>? paymentMethods;
  List<String>? standards;
  Rating? rating;
  Status? relatedArticles;
  String? fullPathUrl;

  detail_place({
    this.placeId,
    this.status,
    this.name,
    this.category,
    this.information,
    this.sha,
    this.latitude,
    this.longitude,
    this.location,
    this.contact,
    this.company,
    this.branches,
    this.logoUrl,
    this.thumbnailUrl,
    this.desktopImageUrls,
    this.mobileImageUrls,
    this.hitScore,
    this.tags,
    this.googleMapUrl,
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.awards,
    this.minPrice,
    this.maxPrice,
    this.specialCloseText,
    this.openingHours,
    this.facilities,
    this.services,
    this.paymentMethods,
    this.standards,
    this.rating,
    this.relatedArticles,
    this.fullPathUrl,
  });

  detail_place.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing detail_place from: ${json.keys}');

      placeId = json['placeId'];
      print('📍 PlaceId: $placeId');

      // Status - แก้ไขให้รองรับ String และ Object
      try {
        if (json['status'] != null) {
          status = Status.fromJson(json['status']);
        }
      } catch (e) {
        print('⚠️ Error parsing status: $e');
        // ถ้า status เป็น string ธรรมดา
        if (json['status'] is String) {
          status = Status(status: json['status']);
        } else {
          status = null;
        }
      }

      name = json['name'];
      print('🏷️ Name: $name');

      // Category - safe parsing
      try {
        category =
            json['category'] != null
                ? Category.fromJson(json['category'])
                : null;
      } catch (e) {
        print('⚠️ Error parsing category: $e');
        category = null;
      }

      // Information - safe parsing
      try {
        information =
            json['information'] != null
                ? Information.fromJson(json['information'])
                : null;
      } catch (e) {
        print('⚠️ Error parsing information: $e');
        information = null;
      }

      // SHA - safe parsing
      try {
        sha = json['sha'] != null ? Sha.fromJson(json['sha']) : null;
      } catch (e) {
        print('⚠️ Error parsing sha: $e');
        sha = null;
      }

      latitude = json['latitude'];
      longitude = json['longitude'];

      // Location - safe parsing
      try {
        location =
            json['location'] != null
                ? Location.fromJson(json['location'])
                : null;
      } catch (e) {
        print('⚠️ Error parsing location: $e');
        location = null;
      }

      // Contact - safe parsing
      try {
        contact =
            json['contact'] != null ? Contact.fromJson(json['contact']) : null;
      } catch (e) {
        print('⚠️ Error parsing contact: $e');
        contact = null;
      }

      // Company - safe parsing
      try {
        company =
            json['company'] != null ? Company.fromJson(json['company']) : null;
      } catch (e) {
        print('⚠️ Error parsing company: $e');
        company = null;
      }

      // Branches - safe parsing
      branches = _parseBranches(json['branches']);

      logoUrl = json['logoUrl'];
      thumbnailUrl = json['thumbnailUrl'];

      // Image URLs - safe parsing
      desktopImageUrls = _parseStringList(json['desktopImageUrls']);
      mobileImageUrls = _parseStringList(json['mobileImageUrls']);

      hitScore = json['hitScore'];

      // Tags - safe parsing
      tags = _parseStringList(json['tags']);

      googleMapUrl = json['googleMapUrl'];
      distance = json['distance'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];

      // Awards - safe parsing
      awards = _parseAwards(json['awards']);

      minPrice = json['minPrice'];
      maxPrice = json['maxPrice'];
      specialCloseText = json['specialCloseText'];

      // Opening Hours - safe parsing
      openingHours = _parseOpeningHours(json['openingHours']);

      // Facilities - safe parsing
      facilities = _parseFacilities(json['facilities']);

      // Services, Payment Methods, Standards - safe parsing
      services = _parseStringList(json['services']);
      paymentMethods = _parseStringList(json['paymentMethods']);
      standards = _parseStringList(json['standards']);

      // Rating - safe parsing
      try {
        rating =
            json['rating'] != null ? Rating.fromJson(json['rating']) : null;
      } catch (e) {
        print('⚠️ Error parsing rating: $e');
        rating = null;
      }

      // Related Articles - safe parsing
      try {
        relatedArticles =
            json['related_articles'] != null
                ? Status.fromJson(json['related_articles'])
                : null;
      } catch (e) {
        print('⚠️ Error parsing relatedArticles: $e');
        relatedArticles = null;
      }

      fullPathUrl = json['fullPathUrl'];

      print('✅ Successfully parsed detail_place: $name');
    } catch (e) {
      print('❌ Major error parsing detail_place: $e');
      print('📋 JSON keys: ${json.keys}');
      _setDefaults();
      rethrow;
    }
  }

  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString())
          .where((str) => str.isNotEmpty && str != 'null')
          .toList();
    }

    if (value is String && value.isNotEmpty) {
      return [value];
    }

    return [];
  }

  List<Branches>? _parseBranches(dynamic value) {
    if (value == null || !(value is List)) return null;

    List<Branches> branches = [];
    for (var item in value) {
      try {
        branches.add(Branches.fromJson(item));
      } catch (e) {
        print('⚠️ Error parsing branch: $e');
      }
    }
    return branches.isEmpty ? null : branches;
  }

  List<Awards>? _parseAwards(dynamic value) {
    if (value == null || !(value is List)) return null;

    List<Awards> awards = [];
    for (var item in value) {
      try {
        awards.add(Awards.fromJson(item));
      } catch (e) {
        print('⚠️ Error parsing award: $e');
      }
    }
    return awards.isEmpty ? null : awards;
  }

  List<OpeningHours>? _parseOpeningHours(dynamic value) {
    if (value == null || !(value is List)) return null;

    List<OpeningHours> hours = [];
    for (var item in value) {
      try {
        hours.add(OpeningHours.fromJson(item));
      } catch (e) {
        print('⚠️ Error parsing opening hour: $e');
      }
    }
    return hours.isEmpty ? null : hours;
  }

  List<Facilities>? _parseFacilities(dynamic value) {
    if (value == null || !(value is List)) return null;

    List<Facilities> facilities = [];
    for (var item in value) {
      try {
        facilities.add(Facilities.fromJson(item));
      } catch (e) {
        print('⚠️ Error parsing facility: $e');
      }
    }
    return facilities.isEmpty ? null : facilities;
  }

  void _setDefaults() {
    desktopImageUrls ??= [];
    mobileImageUrls ??= [];
    tags ??= [];
    services ??= [];
    paymentMethods ??= [];
    standards ??= [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeId'] = placeId;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['name'] = name;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (information != null) {
      data['information'] = information!.toJson();
    }
    if (sha != null) {
      data['sha'] = sha!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (branches != null) {
      data['branches'] = branches!.map((v) => v.toJson()).toList();
    }
    data['logoUrl'] = logoUrl;
    data['thumbnailUrl'] = thumbnailUrl;
    data['desktopImageUrls'] = desktopImageUrls;
    data['mobileImageUrls'] = mobileImageUrls;
    data['hitScore'] = hitScore;
    data['tags'] = tags;
    data['googleMapUrl'] = googleMapUrl;
    data['distance'] = distance;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (awards != null) {
      data['awards'] = awards!.map((v) => v.toJson()).toList();
    }
    data['minPrice'] = minPrice;
    data['maxPrice'] = maxPrice;
    data['specialCloseText'] = specialCloseText;
    if (openingHours != null) {
      data['openingHours'] = openingHours!.map((v) => v.toJson()).toList();
    }
    if (facilities != null) {
      data['facilities'] = facilities!.map((v) => v.toJson()).toList();
    }
    data['services'] = services;
    data['paymentMethods'] = paymentMethods;
    data['standards'] = standards;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    if (relatedArticles != null) {
      data['related_articles'] = relatedArticles!.toJson();
    }
    data['fullPathUrl'] = fullPathUrl;
    return data;
  }
}

class Status {
  String? status;
  String? code;

  Status({this.status, this.code});

  Status.fromJson(dynamic json) {
    if (json is String) {
      status = json;
    } else if (json is Map<String, dynamic>) {
      status = json['status'];
      code = json['code'];
    } else {
      status = json?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (code != null) data['code'] = code;
    return data;
  }
}

class Category {
  int? categoryId;
  String? name;
  List<SubCategories>? subCategories;

  Category({this.categoryId, this.name, this.subCategories});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategories>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['name'] = name;
    if (subCategories != null) {
      data['subCategories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? subCategoryId;
  String? name;

  SubCategories({this.subCategoryId, this.name});

  SubCategories.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subCategoryId'] = subCategoryId;
    data['name'] = name;
    return data;
  }
}

class Information {
  String? introduction;
  String? detail;
  List<String>? activities;
  List<String>? targets;
  String? registerLicenseId;
  String? hotelStar;
  String? checkInTime;
  String? checkOutTime;
  String? numberOfRooms;
  String? rooms;
  List<Cuisines>? cuisines;
  Fee? fee;

  Information({
    this.introduction,
    this.detail,
    this.activities,
    this.targets,
    this.registerLicenseId,
    this.hotelStar,
    this.checkInTime,
    this.checkOutTime,
    this.numberOfRooms,
    this.rooms,
    this.cuisines,
    this.fee,
  });

  Information.fromJson(Map<String, dynamic> json) {
    try {
      introduction = json['introduction'];
      detail = json['detail'];

      activities = _parseStringList(json['activities']);
      targets = _parseStringList(json['targets']);

      registerLicenseId = json['register_license_id'];
      hotelStar = json['hotel_star'];
      checkInTime = json['check_in_time'];
      checkOutTime = json['check_out_time'];
      numberOfRooms = json['number_of_rooms'];
      rooms = json['rooms'];

      if (json['cuisines'] != null && json['cuisines'] is List) {
        cuisines = <Cuisines>[];
        (json['cuisines'] as List).forEach((v) {
          try {
            cuisines!.add(Cuisines.fromJson(v));
          } catch (e) {
            print('⚠️ Error parsing cuisine: $e');
          }
        });
      }

      fee = json['fee'] != null ? Fee.fromJson(json['fee']) : null;
    } catch (e) {
      print('❌ Error parsing Information: $e');
      activities = [];
      targets = [];
    }
  }

  List<String>? _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString())
          .where((str) => str.isNotEmpty && str != 'null')
          .toList();
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['introduction'] = introduction;
    data['detail'] = detail;
    data['activities'] = activities;
    data['targets'] = targets;
    data['register_license_id'] = registerLicenseId;
    data['hotel_star'] = hotelStar;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['number_of_rooms'] = numberOfRooms;
    data['rooms'] = rooms;
    if (cuisines != null) {
      data['cuisines'] = cuisines!.map((v) => v.toJson()).toList();
    }
    if (fee != null) {
      data['fee'] = fee!.toJson();
    }
    return data;
  }
}

class Cuisines {
  int? cuisineId;
  String? name;

  Cuisines({this.cuisineId, this.name});

  Cuisines.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisineId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cuisineId'] = cuisineId;
    data['name'] = name;
    return data;
  }
}

class Fee {
  int? thaiChild;
  int? thaiAdult;
  int? foreignerChild;
  int? foreignerAdult;

  Fee({
    this.thaiChild,
    this.thaiAdult,
    this.foreignerChild,
    this.foreignerAdult,
  });

  Fee.fromJson(Map<String, dynamic> json) {
    thaiChild = json['thaiChild'];
    thaiAdult = json['thaiAdult'];
    foreignerChild = json['foreignerChild'];
    foreignerAdult = json['foreignerAdult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thaiChild'] = thaiChild;
    data['thaiAdult'] = thaiAdult;
    data['foreignerChild'] = foreignerChild;
    data['foreignerAdult'] = foreignerAdult;
    return data;
  }
}

class Sha {
  String? name;
  String? detail;
  String? thumbnailUrl;
  String? detailThumbnail;
  List<String>? detailPicture;
  Type? type;
  Category? category;

  Sha({
    this.name,
    this.detail,
    this.thumbnailUrl,
    this.detailThumbnail,
    this.detailPicture,
    this.type,
    this.category,
  });

  Sha.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'];
      detail = json['detail'];
      thumbnailUrl = json['thumbnailUrl'];
      detailThumbnail = json['detailThumbnail'];

      // Safe casting for detailPicture
      if (json['detailPicture'] != null) {
        if (json['detailPicture'] is List) {
          detailPicture =
              (json['detailPicture'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        detailPicture = [];
      }

      type = json['type'] != null ? Type.fromJson(json['type']) : null;
      category =
          json['category'] != null ? Category.fromJson(json['category']) : null;
    } catch (e) {
      print('❌ Error parsing Sha: $e');
      detailPicture = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['detail'] = detail;
    data['thumbnailUrl'] = thumbnailUrl;
    data['detailThumbnail'] = detailThumbnail;
    data['detailPicture'] = detailPicture;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeId'] = typeId;
    data['name'] = name;
    return data;
  }
}

class CategorySection {
  int? categoryId;
  String? name;
  String? icon;

  CategorySection({this.categoryId, this.name, this.icon});

  CategorySection.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}

class Location {
  String? address;
  Province? province;
  District? district;
  SubDistrict? subDistrict;
  String? postcode;
  String? area;
  String? howToTravel;

  Location({
    this.address,
    this.province,
    this.district,
    this.subDistrict,
    this.postcode,
    this.area,
    this.howToTravel,
  });

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    province =
        json['province'] != null ? Province.fromJson(json['province']) : null;
    district =
        json['district'] != null ? District.fromJson(json['district']) : null;
    subDistrict =
        json['subDistrict'] != null
            ? SubDistrict.fromJson(json['subDistrict'])
            : null;
    postcode = json['postcode'];
    area = json['area'];
    howToTravel = json['howToTravel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    if (province != null) {
      data['province'] = province!.toJson();
    }
    if (district != null) {
      data['district'] = district!.toJson();
    }
    if (subDistrict != null) {
      data['subDistrict'] = subDistrict!.toJson();
    }
    data['postcode'] = postcode;
    data['area'] = area;
    data['howToTravel'] = howToTravel;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinceId'] = provinceId;
    data['name'] = name;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['districtId'] = districtId;
    data['name'] = name;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subDistrictId'] = subDistrictId;
    data['name'] = name;
    return data;
  }
}

class Contact {
  List<String>? phones;
  List<String>? mobiles;
  List<String>? faxes;
  List<String>? emails;
  List<String>? urls;

  Contact({this.phones, this.mobiles, this.faxes, this.emails, this.urls});

  Contact.fromJson(Map<String, dynamic> json) {
    try {
      // Safe casting for phones
      if (json['phones'] != null) {
        if (json['phones'] is List) {
          phones =
              (json['phones'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        phones = [];
      }

      // Safe casting for mobiles
      if (json['mobiles'] != null) {
        if (json['mobiles'] is List) {
          mobiles =
              (json['mobiles'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        mobiles = [];
      }

      // Safe casting for faxes
      if (json['faxes'] != null) {
        if (json['faxes'] is List) {
          faxes =
              (json['faxes'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        faxes = [];
      }

      // Safe casting for emails
      if (json['emails'] != null) {
        if (json['emails'] is List) {
          emails =
              (json['emails'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        emails = [];
      }

      // Safe casting for urls
      if (json['urls'] != null) {
        if (json['urls'] is List) {
          urls =
              (json['urls'] as List)
                  .where((item) => item != null)
                  .map((item) => item.toString())
                  .toList();
        }
      } else {
        urls = [];
      }
    } catch (e) {
      print('❌ Error parsing Contact: $e');
      phones = [];
      mobiles = [];
      faxes = [];
      emails = [];
      urls = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phones'] = phones;
    data['mobiles'] = mobiles;
    data['faxes'] = faxes;
    data['emails'] = emails;
    data['urls'] = urls;
    return data;
  }
}

class Company {
  String? name;
  String? licenseNumber;
  String? certificateUrl;
  String? certificateExpiredAt;
  Contact? contact;

  Company({
    this.name,
    this.licenseNumber,
    this.certificateUrl,
    this.certificateExpiredAt,
    this.contact,
  });

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    licenseNumber = json['license_number'];
    certificateUrl = json['certificate_url'];
    certificateExpiredAt = json['certificate_expired_at'];
    contact =
        json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['license_number'] = licenseNumber;
    data['certificate_url'] = certificateUrl;
    data['certificate_expired_at'] = certificateExpiredAt;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}

class Contacts {
  String? firstName;
  String? lastName;
  String? phone;
  String? email;

  Contacts({this.firstName, this.lastName, this.phone, this.email});

  Contacts.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}

class Branches {
  String? id;
  String? name;

  Branches({this.id, this.name});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Awards {
  int? awardId;
  int? year;
  String? name;

  Awards({this.awardId, this.year, this.name});

  Awards.fromJson(Map<String, dynamic> json) {
    awardId = json['award_id'];
    year = json['year'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['award_id'] = awardId;
    data['year'] = year;
    data['name'] = name;
    return data;
  }
}

class OpeningHours {
  String? day;
  String? open;
  String? close;

  OpeningHours({this.day, this.open, this.close});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    open = json['open'];
    close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}

class Facilities {
  String? code;
  String? name;

  Facilities({this.code, this.name});

  Facilities.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class Rating {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;
  int? rating;
  String? ratingText;
  int? all;

  Rating({
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.rating,
    this.ratingText,
    this.all,
  });

  Rating.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
    rating = json['rating'];
    ratingText = json['rating_text'];
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = i1;
    data['2'] = i2;
    data['3'] = i3;
    data['4'] = i4;
    data['5'] = i5;
    data['rating'] = rating;
    data['rating_text'] = ratingText;
    data['all'] = all;
    return data;
  }
}
