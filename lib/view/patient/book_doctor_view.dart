import 'package:healty_ways/resources/components/patient/doctor_card.dart';
import 'package:healty_ways/resources/widgets/reusable_text_field.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/doctors_view_model.dart';

class BookDoctorView extends StatelessWidget {
  final DoctorsViewModel _viewModel = Get.find<DoctorsViewModel>();
  final TextEditingController _searchController = TextEditingController();

  BookDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildDoctorList()),
        ],
      ),
    );
  }

  ReusableAppBar _buildAppBar() {
    return ReusableAppBar(
      titleText: "Doctors",
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
      hintText: 'Search by name, specialty or location...',
      prefixIcon: const Icon(Icons.search),
      onChanged: _viewModel.updateSearchQuery,
    );
  }

  Widget _buildDoctorList() {
    return Obx(() {
      if (_viewModel.isLoading && _viewModel.doctors.isEmpty) {
        return _buildLoadingIndicator();
      }

      if (_viewModel.doctors.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: _viewModel.fetchAllDoctors,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _viewModel.doctors.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildDoctorCard(index),
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
          const Icon(Icons.medical_services, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'No doctors available'
                : 'No matching doctors found',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (_searchController.text.isNotEmpty)
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Clear search'),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(int index) {
    final doctor = _viewModel.doctors[index];
    return DoctorCard(
      doctor: doctor,
      onTap: () => Get.toNamed(
        RouteName.patientBookDoctorDetails,
        arguments: doctor,
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    _viewModel.updateSearchQuery('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    // super.dispose();
  }
}
