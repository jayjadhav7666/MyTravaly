import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travely/auth/bloc/auth_bloc.dart';
import 'package:my_travely/auth/ui/login_page.dart';
import 'package:my_travely/constants/colors.dart';
import 'package:my_travely/homePage/bloc/home_bloc.dart';
import 'package:my_travely/homePage/repository/hotel_repository.dart';
import 'package:my_travely/search_auto_complete/ui/explore_card.dart';
import 'package:my_travely/homePage/ui/widget/hotel_card.dart';
import 'package:my_travely/utils/hotel_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HotelRepository())
        ..add(
          FetchHotelsEvent(
            'Pune Division',
            'Maharastra',
            'India',
          ),
        ),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutEvent());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      icon: Icon(
                        Icons.logout,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const ExploreSearchCard(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoadingState) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (_, __) => const HotelShimmer(),
                        );
                      } else if (state is HomeErrorState) {
                        return Center(
                            child: Text('Error: ${state.errorMessage}',
                                style: const TextStyle(color: Colors.red)));
                      } else if (state is HomeLoadedState) {
                        final hotels = state.hotels;
                        if (hotels.isEmpty) {
                          return const Center(child: Text('No hotels found.'));
                        }
                        return ListView.separated(
                          itemCount: hotels.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return HotelCard(hotel: hotels[index]);
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
