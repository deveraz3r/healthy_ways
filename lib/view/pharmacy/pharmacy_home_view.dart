import 'package:healty_ways/resources/components/pharmacy/orders_summary_chart.dart';
import 'package:healty_ways/resources/components/shared/home_button.dart';
import 'package:healty_ways/resources/components/shared/reusable_user_profile_card.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/order_view_model.dart';
import 'package:healty_ways/view_model/patients_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class PharmacyHomeView extends StatelessWidget {
  PharmacyHomeView({super.key});

  final ProfileViewModel _profileVM = Get.put(ProfileViewModel());
  final MedicineViewModel _medicineVM = Get.put(MedicineViewModel());
  final OrderViewModel _orderVM = Get.put(OrderViewModel());
  final InventoryViewModel _inventoryVM = Get.put(InventoryViewModel());

  @override
  void initState() {
    // super.initState();
    // fetchOrders();
  }

  Future<void> fetchOrders() async {
    await _orderVM.fetchUserOrders(
      Get.find<ProfileViewModel>().profile?.uid ?? "",
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        appBarTitle: ReusableUserProfileCard(),
        titleText: "",
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteName.chatView);
            },
            icon: Icon(
              Icons.chat_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                // OrdersSummaryChart(),  //TODO: add chart
                const SizedBox(height: 10),
                _buildGridButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridButtons() {
    return GridView.count(
      shrinkWrap: true, // Prevent nested scrolling
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 8, // Horizontal spacing between items
      mainAxisSpacing: 8, // Vertical spacing between items
      childAspectRatio: 4, // Rectangular shape
      padding: EdgeInsets.zero,
      children: [
        HomeButton(
          title: 'Orders',
          onTap: () async {
            fetchOrders();
            Get.toNamed(RouteName.pharmacyOrdersRequestView);
          },
          color: AppColors.orangeColor,
        ),
        // HomeButton(
        //   title: 'Dlivery Status',
        //   onTap: () {
        //     Get.toNamed(RouteName.pharmacyDeliveryStatusView);
        //   },
        //   color: AppColors.blueColor,
        // ),
        HomeButton(
          title: 'Inventory',
          onTap: () async {
            await _inventoryVM.fetchInventory();
            Get.toNamed(RouteName.pharmacyInventoryView);
          },
          color: AppColors.purpleColor,
        ),
        HomeButton(
          title: 'Lab',
          onTap: () {
            Get.toNamed(RouteName.pharmacyLabRecords);
          },
          color: AppColors.redColor,
        ),
      ],
    );
  }
}
