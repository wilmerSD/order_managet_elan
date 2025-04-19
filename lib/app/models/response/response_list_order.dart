class ResponseListOrder {
    final int? id;
    final int? parentId;
    final String? status;
    final String? currency;
    final String? version;
    final bool? pricesIncludeTax;
    final DateTime? dateCreated;
    final DateTime? dateModified;
    final String? discountTotal;
    final String? discountTax;
    final String? shippingTotal;
    final String? shippingTax;
    final String? cartTax;
    final String? total;
    final String? totalTax;
    final int? customerId;
    final String? orderKey;
    final Ing? billing;
    final Ing? shipping;
    final String? paymentMethod;
    final String? paymentMethodTitle;
    final String? transactionId;
    final String? customerIpAddress;
    final String? customerUserAgent;
    final String? createdVia;
    final String? customerNote;
    final dynamic dateCompleted;
    final dynamic datePaid;
    final String? cartHash;
    final String? number;
    final List<MetaDatum>? metaData;
    final List<LineItem>? lineItems;
    final List<dynamic>? taxLines;
    final List<dynamic>? shippingLines;
    final List<dynamic>? feeLines;
    final List<dynamic>? couponLines;
    final List<dynamic>? refunds;
    final String? paymentUrl;
    final bool? isEditable;
    final bool? needsPayment;
    final bool? needsProcessing;
    final DateTime? dateCreatedGmt;
    final DateTime? dateModifiedGmt;
    final dynamic dateCompletedGmt;
    final dynamic datePaidGmt;
    final String? currencySymbol;
    final Links? links;

    ResponseListOrder({
        this.id,
        this.parentId,
        this.status,
        this.currency,
        this.version,
        this.pricesIncludeTax,
        this.dateCreated,
        this.dateModified,
        this.discountTotal,
        this.discountTax,
        this.shippingTotal,
        this.shippingTax,
        this.cartTax,
        this.total,
        this.totalTax,
        this.customerId,
        this.orderKey,
        this.billing,
        this.shipping,
        this.paymentMethod,
        this.paymentMethodTitle,
        this.transactionId,
        this.customerIpAddress,
        this.customerUserAgent,
        this.createdVia,
        this.customerNote,
        this.dateCompleted,
        this.datePaid,
        this.cartHash,
        this.number,
        this.metaData,
        this.lineItems,
        this.taxLines,
        this.shippingLines,
        this.feeLines,
        this.couponLines,
        this.refunds,
        this.paymentUrl,
        this.isEditable,
        this.needsPayment,
        this.needsProcessing,
        this.dateCreatedGmt,
        this.dateModifiedGmt,
        this.dateCompletedGmt,
        this.datePaidGmt,
        this.currencySymbol,
        this.links,
    });

    factory ResponseListOrder.fromJson(Map<String, dynamic> json) => ResponseListOrder(
        id: json["id"],
        parentId: json["parent_id"],
        status: json["status"],
        currency: json["currency"],
        version: json["version"],
        pricesIncludeTax: json["prices_include_tax"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
        discountTotal: json["discount_total"],
        discountTax: json["discount_tax"],
        shippingTotal: json["shipping_total"],
        shippingTax: json["shipping_tax"],
        cartTax: json["cart_tax"],
        total: json["total"],
        totalTax: json["total_tax"],
        customerId: json["customer_id"],
        orderKey: json["order_key"],
        billing: json["billing"] == null ? null : Ing.fromJson(json["billing"]),
        shipping: json["shipping"] == null ? null : Ing.fromJson(json["shipping"]),
        paymentMethod: json["payment_method"],
        paymentMethodTitle: json["payment_method_title"],
        transactionId: json["transaction_id"],
        customerIpAddress: json["customer_ip_address"],
        customerUserAgent: json["customer_user_agent"],
        createdVia: json["created_via"],
        customerNote: json["customer_note"],
        dateCompleted: json["date_completed"],
        datePaid: json["date_paid"],
        cartHash: json["cart_hash"],
        number: json["number"],
        metaData: json["meta_data"] == null ? [] : List<MetaDatum>.from(json["meta_data"]!.map((x) => MetaDatum.fromJson(x))),
        lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"]!.map((x) => LineItem.fromJson(x))),
        taxLines: json["tax_lines"] == null ? [] : List<dynamic>.from(json["tax_lines"]!.map((x) => x)),
        shippingLines: json["shipping_lines"] == null ? [] : List<dynamic>.from(json["shipping_lines"]!.map((x) => x)),
        feeLines: json["fee_lines"] == null ? [] : List<dynamic>.from(json["fee_lines"]!.map((x) => x)),
        couponLines: json["coupon_lines"] == null ? [] : List<dynamic>.from(json["coupon_lines"]!.map((x) => x)),
        refunds: json["refunds"] == null ? [] : List<dynamic>.from(json["refunds"]!.map((x) => x)),
        paymentUrl: json["payment_url"],
        isEditable: json["is_editable"],
        needsPayment: json["needs_payment"],
        needsProcessing: json["needs_processing"],
        dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
        dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
        dateCompletedGmt: json["date_completed_gmt"],
        datePaidGmt: json["date_paid_gmt"],
        currencySymbol: json["currency_symbol"],
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "status": status,
        "currency": currency,
        "version": version,
        "prices_include_tax": pricesIncludeTax,
        "date_created": dateCreated?.toIso8601String(),
        "date_modified": dateModified?.toIso8601String(),
        "discount_total": discountTotal,
        "discount_tax": discountTax,
        "shipping_total": shippingTotal,
        "shipping_tax": shippingTax,
        "cart_tax": cartTax,
        "total": total,
        "total_tax": totalTax,
        "customer_id": customerId,
        "order_key": orderKey,
        "billing": billing?.toJson(),
        "shipping": shipping?.toJson(),
        "payment_method": paymentMethod,
        "payment_method_title": paymentMethodTitle,
        "transaction_id": transactionId,
        "customer_ip_address": customerIpAddress,
        "customer_user_agent": customerUserAgent,
        "created_via": createdVia,
        "customer_note": customerNote,
        "date_completed": dateCompleted,
        "date_paid": datePaid,
        "cart_hash": cartHash,
        "number": number,
        "meta_data": metaData == null ? [] : List<dynamic>.from(metaData!.map((x) => x.toJson())),
        "line_items": lineItems == null ? [] : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "tax_lines": taxLines == null ? [] : List<dynamic>.from(taxLines!.map((x) => x)),
        "shipping_lines": shippingLines == null ? [] : List<dynamic>.from(shippingLines!.map((x) => x)),
        "fee_lines": feeLines == null ? [] : List<dynamic>.from(feeLines!.map((x) => x)),
        "coupon_lines": couponLines == null ? [] : List<dynamic>.from(couponLines!.map((x) => x)),
        "refunds": refunds == null ? [] : List<dynamic>.from(refunds!.map((x) => x)),
        "payment_url": paymentUrl,
        "is_editable": isEditable,
        "needs_payment": needsPayment,
        "needs_processing": needsProcessing,
        "date_created_gmt": dateCreatedGmt?.toIso8601String(),
        "date_modified_gmt": dateModifiedGmt?.toIso8601String(),
        "date_completed_gmt": dateCompletedGmt,
        "date_paid_gmt": datePaidGmt,
        "currency_symbol": currencySymbol,
        "_links": links?.toJson(),
    };
}

class Ing {
    final String? firstName;
    final String? lastName;
    final String? company;
    final String? address1;
    final String? address2;
    final String? city;
    final String? state;
    final String? postcode;
    final String? country;
    final String? email;
    final String? phone;

    Ing({
        this.firstName,
        this.lastName,
        this.company,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.postcode,
        this.country,
        this.email,
        this.phone,
    });

    factory Ing.fromJson(Map<String, dynamic> json) => Ing(
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        state: json["state"],
        postcode: json["postcode"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "email": email,
        "phone": phone,
    };
}

class LineItem {
    final int? id;
    final String? name;
    final int? productId;
    final int? variationId;
    final int? quantity;
    final String? taxClass;
    final String? subtotal;
    final String? subtotalTax;
    final String? total;
    final String? totalTax;
    final List<dynamic>? taxes;
    final List<dynamic>? metaData;
    final String? sku;
    final double? price;
    final Image? image;
    final dynamic parentName;

    LineItem({
        this.id,
        this.name,
        this.productId,
        this.variationId,
        this.quantity,
        this.taxClass,
        this.subtotal,
        this.subtotalTax,
        this.total,
        this.totalTax,
        this.taxes,
        this.metaData,
        this.sku,
        this.price,
        this.image,
        this.parentName,
    });

    factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        name: json["name"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        quantity: json["quantity"],
        taxClass: json["tax_class"],
        subtotal: json["subtotal"],
        subtotalTax: json["subtotal_tax"],
        total: json["total"],
        totalTax: json["total_tax"],
        taxes: json["taxes"] == null ? [] : List<dynamic>.from(json["taxes"]!.map((x) => x)),
        metaData: json["meta_data"] == null ? [] : List<dynamic>.from(json["meta_data"]!.map((x) => x)),
        sku: json["sku"],
        price: json["price"]?.toDouble(),
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        parentName: json["parent_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "product_id": productId,
        "variation_id": variationId,
        "quantity": quantity,
        "tax_class": taxClass,
        "subtotal": subtotal,
        "subtotal_tax": subtotalTax,
        "total": total,
        "total_tax": totalTax,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
        "meta_data": metaData == null ? [] : List<dynamic>.from(metaData!.map((x) => x)),
        "sku": sku,
        "price": price,
        "image": image?.toJson(),
        "parent_name": parentName,
    };
}

class Image {
    final String? id;
    final String? src;

    Image({
        this.id,
        this.src,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"]?.toString(),
        src: json["src"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "src": src,
    };
}

class Links {
    final List<Self>? self;
    final List<Collection>? collection;
    final List<Collection>? customer;

    Links({
        this.self,
        this.collection,
        this.customer,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null ? [] : List<Self>.from(json["self"]!.map((x) => Self.fromJson(x))),
        collection: json["collection"] == null ? [] : List<Collection>.from(json["collection"]!.map((x) => Collection.fromJson(x))),
        customer: json["customer"] == null ? [] : List<Collection>.from(json["customer"]!.map((x) => Collection.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
        "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
        "customer": customer == null ? [] : List<dynamic>.from(customer!.map((x) => x.toJson())),
    };
}

class Collection {
    final String? href;

    Collection({
        this.href,
    });

    factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"],
    );

    Map<String, dynamic> toJson() => {
        "href": href,
    };
}

class Self {
    final String? href;
    final TargetHints? targetHints;

    Self({
        this.href,
        this.targetHints,
    });

    factory Self.fromJson(Map<String, dynamic> json) => Self(
        href: json["href"],
        targetHints: json["targetHints"] == null ? null : TargetHints.fromJson(json["targetHints"]),
    );

    Map<String, dynamic> toJson() => {
        "href": href,
        "targetHints": targetHints?.toJson(),
    };
}

class TargetHints {
    final List<String>? allow;

    TargetHints({
        this.allow,
    });

    factory TargetHints.fromJson(Map<String, dynamic> json) => TargetHints(
        allow: json["allow"] == null ? [] : List<String>.from(json["allow"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "allow": allow == null ? [] : List<dynamic>.from(allow!.map((x) => x)),
    };
}

class MetaDatum {
    final int? id;
    final String? key;
    final String? value;

    MetaDatum({
        this.id,
        this.key,
        this.value,
    });

    factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
        id: json["id"],
        key: json["key"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
    };
}