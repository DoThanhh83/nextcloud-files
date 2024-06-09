class Response {
  Ocs? ocs;

  Response({this.ocs});

  Response.fromJson(Map<String, dynamic> json) {
    ocs = json['ocs'] != null ? new Ocs.fromJson(json['ocs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ocs != null) {
      data['ocs'] = this.ocs!.toJson();
    }
    return data;
  }
}

class Ocs {
  Meta? meta;
  Data? data;

  Ocs({this.meta, this.data});

  Ocs.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Meta {
  String? status;
  int? statuscode;
  String? message;
  String? totalitems;
  String? itemsperpage;

  Meta(
      {this.status,
        this.statuscode,
        this.message,
        this.totalitems,
        this.itemsperpage});

  Meta.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statuscode = json['statuscode'];
    message = json['message'];
    totalitems = json['totalitems'];
    itemsperpage = json['itemsperpage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statuscode'] = this.statuscode;
    data['message'] = this.message;
    data['totalitems'] = this.totalitems;
    data['itemsperpage'] = this.itemsperpage;
    return data;
  }
}

class Data {
  List<Property>? property1;
  List<Property>? property2;

  Data({this.property1, this.property2});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['property1'] != null) {
      property1 = <Property>[];
      json['property1'].forEach((v) {
        property1!.add(new Property.fromJson(v));
      });
    }
    if (json['property2'] != null) {
      property2 = <Property>[];
      json['property2'].forEach((v) {
        property2!.add(new Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.property1 != null) {
      data['property1'] = this.property1!.map((v) => v.toJson()).toList();
    }
    if (this.property2 != null) {
      data['property2'] = this.property2!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Property {
  String? subtitle;
  String? title;
  String? link;
  String? iconUrl;
  String? overlayIconUrl;
  String? sinceId;

  Property(
      {this.subtitle,
        this.title,
        this.link,
        this.iconUrl,
        this.overlayIconUrl,
        this.sinceId});

  Property.fromJson(Map<String, dynamic> json) {
    subtitle = json['subtitle'];
    title = json['title'];
    link = json['link'];
    iconUrl = json['iconUrl'];
    overlayIconUrl = json['overlayIconUrl'];
    sinceId = json['sinceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtitle'] = this.subtitle;
    data['title'] = this.title;
    data['link'] = this.link;
    data['iconUrl'] = this.iconUrl;
    data['overlayIconUrl'] = this.overlayIconUrl;
    data['sinceId'] = this.sinceId;
    return data;
  }
}