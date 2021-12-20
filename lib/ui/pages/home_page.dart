import 'package:admin_peka/ui/widget/approved_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../common/styles.dart';
import '../../model/panti_asuhan_model.dart';
import '../../services/firebase/firestore/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18)),
      ),
      child: Column(
        children: [
          _buildListKelolaPanti(),
        ],
      ),
    );
  }

  Widget _buildListKelolaPanti() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            Firestore.firebaseFirestore.collection('panti_asuhan').snapshots(),
        builder: (_, snapshot) {
          List<PantiAsuhanModel> pantiAsuhan = [];
          List<PantiAsuhanModel> approvedPantiAsuhan = [];

          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          for (var doc in snapshot.data!.docs) {
            pantiAsuhan.add(PantiAsuhanModel.fromDatabase(doc));
          }

          for (var item in pantiAsuhan) {
            if (item.approved == true) {
              approvedPantiAsuhan.add(item);
            }
          }

          return snapshot.hasData
              ? Flexible(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      children: approvedPantiAsuhan.map((pantiAsuhan) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) =>
                                  ApprovedDialog(pantiAsuhanModel: pantiAsuhan),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kWhiteBgColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 104,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.network(
                                            pantiAsuhan.imgUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pantiAsuhan.name,
                                            style: blackTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: semiBold,
                                              height: 1.75,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/icons/ic_location.png',
                                                width: 11,
                                                height: 14,
                                              ),
                                              const SizedBox(width: 7),
                                              Flexible(
                                                child: Text(
                                                  pantiAsuhan.address,
                                                  style: greyTextStyle.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: light,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: pantiAsuhan.kebutuhan
                                          .map((kebutuhan) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: pantiAsuhan.kebutuhan
                                                          .indexOf(kebutuhan)
                                                          .isEven
                                                      ? kBlueBgColor
                                                      : kPinkBgColor,
                                                ),
                                                child: Image.asset(
                                                  kebutuhan.image,
                                                  width: 30,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                kebutuhan.name,
                                                style: greyTextStyle.copyWith(
                                                  fontWeight: regular,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
