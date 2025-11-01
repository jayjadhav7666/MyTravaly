import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_travely/search_auto_complete/bloc/search_auto_event.dart';
import 'package:my_travely/search_auto_complete/model/search_auto_model.dart';
import 'package:my_travely/search_result/bloc/search_result_bloc.dart';
import 'package:my_travely/search_result/model/search_result_model.dart';
import 'package:my_travely/search_result/repository/search_result_repository.dart';
import 'package:my_travely/utils/hotel_shimmer.dart';
import '../../search_auto_complete/bloc/search_auto_bloc.dart';

class SearchedResult extends StatefulWidget {
  final ListOfResult selectedLocation;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int rooms;
  final int adults;
  final int childrens;
  final SearchBloc bloc;

  const SearchedResult({
    super.key,
    required this.selectedLocation,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.childrens,
    required this.bloc,
  });

  @override
  State<SearchedResult> createState() => _SearchedResultState();
}

class _SearchedResultState extends State<SearchedResult> {
  late SearchResultBloc _resultBloc;
  late TextEditingController _searchController;
  bool showSuggestions = false;

  int rooms = 1;
  int adults = 1;
  int children = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  ListOfResult? selectedLocation;

  late ScrollController _scrollController;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
    _resultBloc = SearchResultBloc(SearchResultCompleteRepository());
    _searchController =
        TextEditingController(text: widget.selectedLocation.valueToDisplay);
    checkInDate = widget.checkInDate;
    checkOutDate = widget.checkOutDate;
    rooms = widget.rooms;
    adults = widget.adults;
    children = widget.childrens;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Initial API call
    _fetchResults();
    _searchController.addListener(_onSearchChanged);
  }

  void _fetchResults() {
    if (selectedLocation == null) return;
    _resultBloc.add(
      FetchSearchResultEvent(
        checkInDate: DateFormat('yyyy-MM-dd').format(checkInDate!),
        checkOutDate: DateFormat('yyyy-MM-dd').format(checkOutDate!),
        rooms: rooms,
        adults: adults,
        children: children,
        searchType: selectedLocation!.searchArray!.type!,
        searchQuery: selectedLocation!.searchArray!.query.first,
      ),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.bloc.add(GetSearchAutoResultsEvent(query));
      setState(() => showSuggestions = true);
    } else {
      widget.bloc.add(ClearSearchEvent());
      setState(() => showSuggestions = false);
    }
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkInDate ?? DateTime.now())
          : (checkOutDate ?? DateTime.now().add(const Duration(days: 1))),
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (isLoadingMore) return;
    final currentState = _resultBloc.state;

    if (currentState is SearchResultSuccess) {
      if (!currentState.hasMore) {
        return;
      }
      setState(() => isLoadingMore = true);
      _resultBloc.add(
        FetchSearchResultEvent(
          checkInDate: DateFormat('yyyy-MM-dd').format(checkInDate!),
          checkOutDate: DateFormat('yyyy-MM-dd').format(checkOutDate!),
          rooms: rooms,
          adults: adults,
          children: children,
          searchType: selectedLocation!.searchArray!.type!,
          searchQuery: selectedLocation!.searchArray!.query.first,
          append: true,
          offset: currentState.results.data?.arrayOfHotelList.length ?? 0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkIn = DateFormat('dd MMM yyyy').format(widget.checkInDate);
    final checkOut = DateFormat('dd MMM yyyy').format(widget.checkOutDate);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.bloc),
        BlocProvider(create: (_) => _resultBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Stack(
          children: [
            Container(
              height: 160,
              color: Colors.blue.shade900,
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSearchHeader(checkIn, checkOut),
                Expanded(
                  child: BlocListener<SearchResultBloc, SearchResultState>(
                    listenWhen: (previous, current) =>
                        current is SearchResultSuccess,
                    listener: (context, state) {
                      if (mounted && isLoadingMore) {
                        setState(() => isLoadingMore = false);
                      }
                    },
                    child: BlocBuilder<SearchResultBloc, SearchResultState>(
                      builder: (context, state) {
                        if (state is SearchResultLoading) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (_, __) => const HotelShimmer(),
                          );
                        } else if (state is SearchResultError) {
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state is SearchResultSuccess) {
                          final hotels =
                              state.results.data?.arrayOfHotelList ?? [];
                          if (hotels.isEmpty) {
                            return const Center(child: Text("No hotels found"));
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 70),
                            itemCount: hotels.length + 1,
                            itemBuilder: (context, index) {
                              if (index < hotels.length) {
                                return _buildHotelCard(hotels[index]);
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: isLoadingMore
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 2)
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(String checkIn, String checkOut) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              hintText: "Search near by",
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  widget.bloc.add(ClearSearchEvent());
                  setState(() => showSuggestions = false);
                },
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          Stack(
            children: [
              Column(
                children: [
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoBox(
                        icon: Icons.calendar_today,
                        title: "Check In",
                        subtitle: checkInDate == null
                            ? "Select date"
                            : DateFormat('MMM dd, yyyy').format(checkInDate!),
                        onTap: () => _pickDate(isCheckIn: true),
                      ),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _buildInfoBox(
                        icon: Icons.calendar_today_outlined,
                        title: "Check Out",
                        subtitle: checkOutDate == null
                            ? "Select date"
                            : DateFormat('MMM dd, yyyy').format(checkOutDate!),
                        onTap: () => _pickDate(isCheckIn: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showRoomGuestBottomSheet();
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "$rooms Room • $adults Adult • $children Children",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _fetchResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              if (showSuggestions)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
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
                          allResults.addAll(autoList!.byCountry!.listOfResult);
                        }

                        if (allResults.isEmpty) {
                          return const Center(child: Text("No results found"));
                        }

                        return ListView.separated(
                          itemCount: allResults.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
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
    );
  }

  Widget _buildHotelCard(ArrayOfHotelList hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              hotel.propertyImage!.fullUrl ??
                  "https://via.placeholder.com/400x200",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Hotel Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.propertyName ?? "Unknown Hotel",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text("${hotel.propertyStar ?? 0.0}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                    const SizedBox(width: 6),
                    if (hotel.googleReview!.reviewPresent != false)
                      Text(
                        "${hotel.googleReview!.data!.totalUserRating ?? 0} Reviews present",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.black54, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${hotel.propertyAddress?.street ?? ''},${hotel.propertyAddress?.city ?? ''}, ${hotel.propertyAddress?.state ?? ''},${hotel.propertyAddress?.zipcode ?? ''}",
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text("Mobile-only price",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Deluxe Rooms",
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (hotel.markedPrice!.displayAmount != null)
                      Text(
                        "${hotel.markedPrice!.displayAmount}",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      hotel.propertyMinPrice!.displayAmount ?? '—',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
