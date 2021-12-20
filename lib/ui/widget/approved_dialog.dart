import 'package:admin_peka/model/panti_asuhan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../common/navigation.dart';
import '../../common/styles.dart';
import '../../services/firebase/firestore/firestore.dart';
import 'button.dart';
import 'custom_toast.dart';

class ApprovedDialog extends StatefulWidget {
  final PantiAsuhanModel pantiAsuhanModel;
  final bool isRequestPage;

  const ApprovedDialog(
      {Key? key, required this.pantiAsuhanModel, this.isRequestPage = false})
      : super(key: key);

  @override
  _ApprovedDialogState createState() => _ApprovedDialogState();
}

class _ApprovedDialogState extends State<ApprovedDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: kGreyColor,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _refuseRequest,
                  style: ElevatedButton.styleFrom(
                    primary: kWhiteColor,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.isRequestPage ? 'Tolak' : 'Hapus panti asuhan',
                    style: whiteTextStyle.copyWith(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ),
              widget.isRequestPage ? const SizedBox(width: 16) : Wrap(),
              widget.isRequestPage
                  ? Expanded(
                      flex: 1,
                      child:
                          Button(textButton: 'Setuju', onTap: _acceptRequest),
                    )
                  : Wrap(),
            ],
          ),
        ],
        content: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      widget.pantiAsuhanModel.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.pantiAsuhanModel.name,
                  style: blackTextStyle.copyWith(
                      fontWeight: semiBold, fontSize: 16),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_location.png',
                      width: 11,
                      height: 14,
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        widget.pantiAsuhanModel.address,
                        style: greyTextStyle.copyWith(
                            fontSize: 14, fontWeight: regular),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  widget.pantiAsuhanModel.description,
                  style:
                      greyTextStyle.copyWith(height: 1.75, fontWeight: regular),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 70,
                  width: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        widget.pantiAsuhanModel.kebutuhan.map((kebutuhan) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.pantiAsuhanModel.kebutuhan
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
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _acceptRequest() async {
    setState(() => _isLoading = true);
    await Firestore.firebaseFirestore
        .collection('users')
        .doc(widget.pantiAsuhanModel.ownerId)
        .collection('kelola_panti')
        .doc(widget.pantiAsuhanModel.pantiAsuhanId)
        .update({'approved': true}).then((_) async {
      await Firestore.firebaseFirestore
          .collection('panti_asuhan')
          .doc(widget.pantiAsuhanModel.pantiAsuhanId)
          .update({'approved': true}).then((_) {
        Navigation.back();
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Menyetujui panti asuhan berhasil',
          ),
        );

        setState(() => _isLoading = false);
      });
    });
  }

  void _refuseRequest() async {
    setState(() => _isLoading = true);
    await Firestore.firebaseFirestore
        .collection('users')
        .doc(widget.pantiAsuhanModel.ownerId)
        .collection('kelola_panti')
        .doc(widget.pantiAsuhanModel.pantiAsuhanId)
        .delete()
        .then((_) async {
      await Firestore.firebaseFirestore
          .collection('panti_asuhan')
          .doc(widget.pantiAsuhanModel.pantiAsuhanId)
          .delete()
          .then((_) {
        Navigation.back();
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Menolak panti asuhan berhasil',
          ),
        );
        setState(() => _isLoading = false);
      });
    });
  }
}
