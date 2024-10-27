import 'package:fanfiction_tracker_flutter/common/widgets/custom_button.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/custom_textfield.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _inputLinkFormkey = GlobalKey<FormState>();
  final FanficService fanficService = FanficService();
  final TextEditingController _fanficLinkController = TextEditingController();

  @override
  void dispose() {
    _fanficLinkController.dispose();
    super.dispose();
  }

  void findFanfic() {
    fanficService.findFanfic(
      context: context,
      fanficLink: _fanficLinkController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _inputLinkFormkey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _fanficLinkController,
                  hintText: 'Fanfic Link',
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Find Fanfic',
                  onTap: () {
                    if (_inputLinkFormkey.currentState!.validate()) {
                      findFanfic();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
