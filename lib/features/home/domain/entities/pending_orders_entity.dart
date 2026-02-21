class OrderEntity {
  final String id;
  final String storeAvatar;
  final String storeName;
  final String storeAddress;
  final String userAvatar;
  final String userName;
  final String userAddress;
  final double totalPrice;

  OrderEntity({
    required this.id,
    required this.storeAvatar,
    required this.storeName,
    required this.storeAddress,
    required this.userAvatar,
    required this.userName,
    required this.userAddress,
    required this.totalPrice,
  });
  static List<OrderEntity> getDummyData() {
    return [
      OrderEntity(
        id: 'order-001',
        storeAvatar: 'https://picsum.photos/200/200?store1',
        storeName: 'Tech Store',
        storeAddress: 'Nasr City, Cairo',
        userAvatar: 'https://picsum.photos/200/200?user1',
        userName: 'Ahmed Mohamed',
        userAddress: 'Maadi, Cairo',
        totalPrice: 1250.50,
      ),
      OrderEntity(
        id: 'order-002',
        storeAvatar: 'https://picsum.photos/200/200?store2',
        storeName: 'Fashion Hub',
        storeAddress: 'Heliopolis, Cairo',
        userAvatar: 'https://picsum.photos/200/200?user2',
        userName: 'Sara Ali',
        userAddress: 'Zamalek, Cairo',
        totalPrice: 890.00,
      ),
      OrderEntity(
        id: 'order-003',
        storeAvatar: 'https://picsum.photos/200/200?store3',
        storeName: 'Home Essentials',
        storeAddress: 'Dokki, Giza',
        userAvatar: 'https://picsum.photos/200/200?user3',
        userName: 'Omar Khaled',
        userAddress: 'Haram, Giza',
        totalPrice: 2300.75,
      ),
      OrderEntity(
        id: 'order-004',
        storeAvatar: 'https://picsum.photos/200/200?store4',
        storeName: 'Mobile Planet',
        storeAddress: 'Smouha, Alexandria',
        userAvatar: 'https://picsum.photos/200/200?user4',
        userName: 'Mona Adel',
        userAddress: 'Stanley, Alexandria',
        totalPrice: 4200.00,
      ),
      OrderEntity(
        id: 'order-005',
        storeAvatar: 'https://picsum.photos/200/200?store5',
        storeName: 'Gadget Zone',
        storeAddress: 'Tanta City Center',
        userAvatar: 'https://picsum.photos/200/200?user5',
        userName: 'Hassan Ibrahim',
        userAddress: 'El Mahalla, Gharbia',
        totalPrice: 1560.25,
      ),
      OrderEntity(
        id: 'order-006',
        storeAvatar: 'https://picsum.photos/200/200?store6',
        storeName: 'Smart Living',
        storeAddress: 'Sheikh Zayed, Giza',
        userAvatar: 'https://picsum.photos/200/200?user6',
        userName: 'Nour Emad',
        userAddress: '6th October, Giza',
        totalPrice: 780.00,
      ),
      OrderEntity(
        id: 'order-007',
        storeAvatar: 'https://picsum.photos/200/200?store7',
        storeName: 'Elite Market',
        storeAddress: 'Mansoura Downtown',
        userAvatar: 'https://picsum.photos/200/200?user7',
        userName: 'Youssef Tarek',
        userAddress: 'Talkha, Dakahlia',
        totalPrice: 3420.90,
      ),
      OrderEntity(
        id: 'order-008',
        storeAvatar: 'https://picsum.photos/200/200?store8',
        storeName: 'Fresh Basket',
        storeAddress: 'New Cairo',
        userAvatar: 'https://picsum.photos/200/200?user8',
        userName: 'Laila Samir',
        userAddress: 'Rehab City, Cairo',
        totalPrice: 640.30,
      ),
      OrderEntity(
        id: 'order-009',
        storeAvatar: 'https://picsum.photos/200/200?store9',
        storeName: 'Daily Needs',
        storeAddress: 'Ismailia City',
        userAvatar: 'https://picsum.photos/200/200?user9',
        userName: 'Karim Fathy',
        userAddress: 'Port Said',
        totalPrice: 1999.99,
      ),
      OrderEntity(
        id: 'order-010',
        storeAvatar: 'https://picsum.photos/200/200?store10',
        storeName: 'Urban Trends',
        storeAddress: 'Hurghada Marina',
        userAvatar: 'https://picsum.photos/200/200?user10',
        userName: 'Huda Mahmoud',
        userAddress: 'El Gouna',
        totalPrice: 2750.40,
      ),
    ];
  }
}
