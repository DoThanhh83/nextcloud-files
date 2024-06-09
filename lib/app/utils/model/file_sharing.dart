class FileSharing {
  String? id;
  int? shareType;
  String? uidOwner;
  String? displaynameOwner;
  int? permissions;
  bool? canEdit;
  bool? canDelete;
  int? stime;
  dynamic parent;
  dynamic expiration;
  dynamic token;
  String? uidFileOwner;
  String? note;
  String? label;
  String? displaynameFileOwner;
  String? path;
  String? itemType;
  String? mimetype;
  bool? hasPreview;
  String? storageId;
  int? storage;
  int? itemSource;
  int? fileSource;
  int? fileParent;
  String? fileTarget;
  int? itemSize;
  int? itemMtime;
  String? shareWith;
  String? shareWithDisplayname;
  String? shareWithDisplaynameUnique;
  Status? status;
  int? mailSend;
  int? hideDownload;
  dynamic attributes;
    // List<Null>? tags;

  FileSharing(
      {this.id,
        this.shareType,
        this.uidOwner,
        this.displaynameOwner,
        this.permissions,
        this.canEdit,
        this.canDelete,
        this.stime,
        this.parent,
        this.expiration,
        this.token,
        this.uidFileOwner,
        this.note,
        this.label,
        this.displaynameFileOwner,
        this.path,
        this.itemType,
        this.mimetype,
        this.hasPreview,
        this.storageId,
        this.storage,
        this.itemSource,
        this.fileSource,
        this.fileParent,
        this.fileTarget,
        this.itemSize,
        this.itemMtime,
        this.shareWith,
        this.shareWithDisplayname,
        this.shareWithDisplaynameUnique,
        this.status,
        this.mailSend,
        this.hideDownload,
        this.attributes,
        // this.tags
      });

  FileSharing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shareType = json['share_type'];
    uidOwner = json['uid_owner'];
    displaynameOwner = json['displayname_owner'];
    permissions = json['permissions'];
    canEdit = json['can_edit'];
    canDelete = json['can_delete'];
    stime = json['stime'];
    parent = json['parent'];
    expiration = json['expiration'];
    token = json['token'];
    uidFileOwner = json['uid_file_owner'];
    note = json['note'];
    label = json['label'];
    displaynameFileOwner = json['displayname_file_owner'];
    path = json['path'];
    itemType = json['item_type'];
    mimetype = json['mimetype'];
    hasPreview = json['has_preview'];
    storageId = json['storage_id'];
    storage = json['storage'];
    itemSource = json['item_source'];
    fileSource = json['file_source'];
    fileParent = json['file_parent'];
    fileTarget = json['file_target'];
    itemSize = json['item_size'];
    itemMtime = json['item_mtime'];
    shareWith = json['share_with'];
    shareWithDisplayname = json['share_with_displayname'];
    shareWithDisplaynameUnique = json['share_with_displayname_unique'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    mailSend = json['mail_send'];
    hideDownload = json['hide_download'];
    attributes = json['attributes'];
    // if (json['tags'] != null) {
    //   tags = <Null>[];
    //   json['tags'].forEach((v) {
    //     tags!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['share_type'] = this.shareType;
    data['uid_owner'] = this.uidOwner;
    data['displayname_owner'] = this.displaynameOwner;
    data['permissions'] = this.permissions;
    data['can_edit'] = this.canEdit;
    data['can_delete'] = this.canDelete;
    data['stime'] = this.stime;
    data['parent'] = this.parent;
    data['expiration'] = this.expiration;
    data['token'] = this.token;
    data['uid_file_owner'] = this.uidFileOwner;
    data['note'] = this.note;
    data['label'] = this.label;
    data['displayname_file_owner'] = this.displaynameFileOwner;
    data['path'] = this.path;
    data['item_type'] = this.itemType;
    data['mimetype'] = this.mimetype;
    data['has_preview'] = this.hasPreview;
    data['storage_id'] = this.storageId;
    data['storage'] = this.storage;
    data['item_source'] = this.itemSource;
    data['file_source'] = this.fileSource;
    data['file_parent'] = this.fileParent;
    data['file_target'] = this.fileTarget;
    data['item_size'] = this.itemSize;
    data['item_mtime'] = this.itemMtime;
    data['share_with'] = this.shareWith;
    data['share_with_displayname'] = this.shareWithDisplayname;
    data['share_with_displayname_unique'] = this.shareWithDisplaynameUnique;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['mail_send'] = this.mailSend;
    data['hide_download'] = this.hideDownload;
    data['attributes'] = this.attributes;
    // if (this.tags != null) {
    //   data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Status {
  String? status;
  String? message;
  String? icon;
  int? clearAt;

  Status({this.status, this.message, this.icon, this.clearAt});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    icon = json['icon'];
    clearAt = json['clearAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['icon'] = this.icon;
    data['clearAt'] = this.clearAt;
    return data;
  }
}
