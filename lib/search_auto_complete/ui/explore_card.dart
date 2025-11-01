import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:my_travely/search_auto_complete/bloc/search_auto_bloc.dart';
import 'package:my_travely/search_auto_complete/bloc/search_auto_event.dart';
import 'package:my_travely/search_auto_complete/repository/search_auto_repository.dart';
import 'package:my_travely/search_auto_complete/model/search_auto_model.dart';
import 'package:my_travely/search_result/ui/searched_result.dart';
import 'package:my_travely/utils/custom_widgest.dart';

class ExploreSearchCard extends StatelessWidget {
  const ExploreSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(SearchAutoRepository()),
      child: const _ExploreSearchCardView(),
    );
  }
}

class _ExploreSearchCardView extends StatefulWidget {
  const _ExploreSearchCardView();

  @override
  State<_ExploreSearchCardView> createState() => _ExploreSearchCardViewState();
}

class _ExploreSearchCardViewState extends State<_ExploreSearchCardView> {
  final TextEditingController _searchController = TextEditingController();
  late SearchBloc _bloc;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int rooms = 1;
  int adults = 1;
  int children = 0;
  bool showSuggestions = false;
  ListOfResult? selectedLocation;

  @override
  void initState() {
    _bloc = context.read<SearchBloc>();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _bloc.add(GetSearchAutoResultsEvent(query));
      setState(() => showSuggestions = true);
    } else {
      _bloc.add(ClearSearchEvent());
      setState(() => showSuggestions = false);
    }
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkInDate ?? DateTime.now())
          : (checkOutDate ??
              (checkInDate ?? DateTime.now()).add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _showRoomGuestBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Rooms and Guests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildCounterRow(
                    "Rooms",
                    rooms,
                    () => setSheetState(
                        () => rooms = (rooms > 1) ? rooms - 1 : 1),
                    () => setSheetState(() => rooms++),
                  ),
                  const SizedBox(height: 10),
                  _buildCounterRow(
                    "Adults",
                    adults,
                    () => setSheetState(
                        () => adults = (adults > 1) ? adults - 1 : 1),
                    () => setSheetState(() => adults++),
                  ),
                  const SizedBox(height: 10),
                  _buildCounterRow(
                    "Children",
                    children,
                    () => setSheetState(
                        () => children = (children > 0) ? children - 1 : 0),
                    () => setSheetState(() => children++),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: const Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 20,
              spreadRadius: 3,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Let's Explore ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.flight_takeoff, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 15),
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: "Search nearby",
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _bloc.add(ClearSearchEvent());
                            setState(() => showSuggestions = false);
                          },
                        )
                      : const Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    // Dates
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildInfoBox(
                            icon: Icons.calendar_today,
                            title: "Check In",
                            subtitle: checkInDate == null
                                ? "Select date"
                                : DateFormat('MMM dd, yyyy')
                                    .format(checkInDate!),
                            onTap: () => _pickDate(isCheckIn: true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoBox(
                            icon: Icons.calendar_today_outlined,
                            title: "Check Out",
                            subtitle: checkOutDate == null
                                ? "Select date"
                                : DateFormat('MMM dd, yyyy')
                                    .format(checkOutDate!),
                            onTap: () => _pickDate(isCheckIn: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Rooms and Guests
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildInfoBox(
                            icon: Icons.meeting_room_outlined,
                            title: "Rooms",
                            subtitle: "$rooms Room${rooms > 1 ? 's' : ''}",
                            onTap: _showRoomGuestBottomSheet,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoBox(
                            icon: Icons.person_outline,
                            title: "Guests",
                            subtitle: "$adults Guest${adults > 1 ? 's' : ''}",
                            onTap: _showRoomGuestBottomSheet,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          String snackBarText = '';
                          if (selectedLocation == null) {
                            snackBarText = 'Please Select Location';
                            print(checkInDate);
                            CustomWidgets.showCustomSnackBar(
                              text: '$checkInDate',
                              context: context,
                              color: Colors.red[300],
                            );
                          } else if (checkInDate == null ||
                              checkOutDate == null) {
                            snackBarText = 'Please Select Date';
                            CustomWidgets.showCustomSnackBar(
                              text: snackBarText,
                              context: context,
                              color: Colors.red[300],
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SearchedResult(
                                  selectedLocation: selectedLocation!,
                                  checkInDate: checkInDate!,
                                  checkOutDate: checkOutDate!,
                                  rooms: rooms,
                                  adults: adults,
                                  childrens: children,
                                  bloc: _bloc,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text(
                          "Search",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                if (showSuggestions)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchAutoLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        } else if (state is SearchAutoSuccessState) {
                          final results = state.results;
                          final autoList = results.data?.autoCompleteList;
                          final List<ListOfResult> allResults = [];

                          if (autoList?.byPropertyName?.present == true) {
                            allResults
                                .addAll(autoList!.byPropertyName!.listOfResult);
                          }
                          if (autoList?.byStreet?.present == true) {
                            allResults.addAll(autoList!.byStreet!.listOfResult);
                          }
                          if (autoList?.byCity?.present == true) {
                            allResults.addAll(autoList!.byCity!.listOfResult);
                          }
                          if (autoList?.byState?.present == true) {
                            allResults.addAll(autoList!.byState!.listOfResult);
                          }
                          if (autoList?.byCountry?.present == true) {
                            allResults
                                .addAll(autoList!.byCountry!.listOfResult);
                          }

                          if (allResults.isEmpty) {
                            return const Center(
                                child: Text("No results found"));
                          }

                          return ListView.separated(
                            itemCount: allResults.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = allResults[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  item.valueToDisplay ?? 'Unknown',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  "${item.address?.city ?? ''} • ${item.address?.state ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                onTap: () {
                                  _searchController.text =
                                      item.valueToDisplay ?? '';
                                  selectedLocation = item;
                                  setState(() => showSuggestions = false);
                                },
                              );
                            },
                          );
                        } else if (state is SearchAutoErrorState) {
                          return const Center(child: Text("No results found"));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    String label,
    int value,
    VoidCallback onDecrement,
    VoidCallback onIncrement,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
                color: Colors.grey,
              ),
              Text('$value', style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.blue.shade900,
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
