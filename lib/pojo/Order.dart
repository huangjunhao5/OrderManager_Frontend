class Order {
  OrderInfo orderInfo;
  List<OrderList> orderLists;

  Order(this.orderInfo, this.orderLists);

  Map<String, dynamic> toJson() {
    return {
      'orderInfo': orderInfo.toJson(),
      'orderLists': orderLists.map((orderList) => orderList.toJson()).toList(),
    };
  }
}

class OrderInfo {
  static const int CreatedFlag = 0;
  static const int EndFlag = 1;
  static const int CanceledFlag = -1;
  String customer;

  OrderInfo(this.customer);

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
    };
  }
}

class OrderList {
  int productId;
  int num;

  OrderList(this.productId, this.num);

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'num': num,
    };
  }
}
