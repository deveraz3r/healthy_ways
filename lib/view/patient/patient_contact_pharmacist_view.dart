import 'package:healty_ways/resources/components/pharmacy/pharmacist_card.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/view_model/pharmacist_view_model.dart';
import 'package:healty_ways/utils/app_urls.dart';

class PatientContactPharmacistView extends StatelessWidget {
  final PharmacistsViewModel _viewModel = Get.find<PharmacistsViewModel>();
  final TextEditingController _searchController = TextEditingController();

  PatientContactPharmacistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildPharmacistList()),
        ],
      ),
    );
  }

  ReusableAppBar _buildAppBar() {
    return ReusableAppBar(
      titleText: "Pharmacists",
      enableBack: true,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildSearchField()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return ReusableTextField(
      controller: _searchController,
      borderRadius: 10,
      hintText: 'Search by name or email...',
      prefixIcon: const Icon(Icons.search),
      onChanged: _viewModel.updateSearchQuery,
    );
  }

  Widget _buildPharmacistList() {
    return Obx(() {
      if (_viewModel.isLoading && _viewModel.pharmacists.isEmpty) {
        return _buildLoadingIndicator();
      }

      if (_viewModel.pharmacists.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: _viewModel.fetchAllPharmacists,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _viewModel.pharmacists.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildPharmacistCard(index),
        ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_pharmacy, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'No pharmacists available'
                : 'No matching pharmacists found',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacistCard(int index) {
    final pharmacist = _viewModel.pharmacists[index];
    return PharmacistCard(
      pharmacist: pharmacist,
      onTap: () => {
        // Get.toNamed(
        //   RouteName
        //       .contactPharmacistView, // Replace with your actual route for chatting
        //   arguments: pharmacist,
        // )
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
  }
}
