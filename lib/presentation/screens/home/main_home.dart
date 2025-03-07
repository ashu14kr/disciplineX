import 'package:anti_procastination/UiTesting/test_roadmap.dart';
import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/controllers/cubit/milestone_cubit.dart';
import 'package:anti_procastination/presentation/screens/home/add_milestone.dart';
import 'package:anti_procastination/presentation/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../storage/model/local_user_model.dart';
import '../../../storage/storage.dart';
import '../setting/profile.dart';
import '../wallet/wallet.dart';
import 'home_helper.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  Storage storage = Storage();

  get() async {
    LocalUserModel? response = await storage.getSignInInfo();
    if (response?.uuid != null) {
      context.read<MilestoneCubit>().getMilestones(response!.uuid);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: CustomFloatingBtn(
        size: size,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMilestone(),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Profile(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "DisciplineX",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GoalProgressScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.graph_square,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Wallet(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.wallet,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Week-1",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                BlocBuilder<MilestoneCubit, MilestoneState>(
                  builder: (context, state) {
                    if (state is MilestoneInitial) {
                      return Container(
                        child: const Center(
                          child: Text(
                            "Testing",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                    if (state is MilestoneLoaded) {
                      return SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.milestone?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: MileStoneCard(
                                ontap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Home(model: state.milestone![index]),
                                    ),
                                  );
                                },
                                model: state.milestone![index],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container(
                        child: const Center(
                          child: Text(
                            "Second Text",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
