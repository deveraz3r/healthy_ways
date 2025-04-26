import 'package:healty_ways/utils/app_urls.dart';

class DoctorAssignedPatientsView extends StatelessWidget {
  final PatientsViewModel _viewModel = Get.find<PatientsViewModel>();

  DoctorAssignedPatientsView({super.key}) {
    _viewModel.fetchAssignedPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(titleText: "Assigned Patients"),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => _viewModel.updateSearchQuery(query),
              decoration: InputDecoration(
                hintText: "Search patients...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Pull-to-Refresh and Patient List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _viewModel.fetchAllPatients();
                _viewModel.fetchAssignedPatients();
              },
              child: Obx(() {
                if (_viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_viewModel.filteredPatients.isEmpty) {
                  return const Center(
                      child: Text("No assigned patients found"));
                }

                return ListView.builder(
                  itemCount: _viewModel.filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = _viewModel.filteredPatients[index];
                    return ListTile(
                      title: Text(patient.fullName),
                      subtitle: Text(patient.email),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
