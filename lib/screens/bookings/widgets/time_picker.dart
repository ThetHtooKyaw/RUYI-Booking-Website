import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class TimePicker extends StatefulWidget {
  final double width;
  final String currentTime;
  final void Function(String) onTimeChanged;

  const TimePicker(
      {super.key,
      required this.onTimeChanged,
      required this.width,
      required this.currentTime});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController periodController;

  int selectedHour = 12;
  int selectedMinute = 0;
  int selectedPeriodIndex = 0;

  @override
  void initState() {
    super.initState();

    final timeParts = widget.currentTime.split(' ');
    final hourMinute = timeParts[0].split(':');
    selectedHour = int.parse(hourMinute[0]);
    selectedMinute = int.parse(hourMinute[1]);
    selectedPeriodIndex = (timeParts[1] == 'PM') ? 1 : 0;

    hourController = FixedExtentScrollController(initialItem: selectedHour - 1);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    periodController =
        FixedExtentScrollController(initialItem: selectedPeriodIndex);

    setState(() {});
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    periodController.dispose();
    super.dispose();
  }

  String get periodString => (selectedPeriodIndex == 0) ? 'AM' : 'PM';

  void _notifyParent() {
    final formattedTime =
        '$selectedHour:${selectedMinute.toString().padLeft(2, '0')} $periodString';
    widget.onTimeChanged(formattedTime);
  }

  void incrementHour() {
    setState(() {
      selectedHour++;
      if (selectedHour > 12) {
        selectedHour = 1;
      }
      _notifyParent();
      hourController.jumpToItem(selectedHour - 1);
    });
  }

  void decrementHour() {
    setState(() {
      selectedHour--;
      if (selectedHour < 1) {
        selectedHour = 12;
      }
      _notifyParent();
      hourController.jumpToItem(selectedHour - 1);
    });
  }

  void incrementMinute() {
    setState(() {
      selectedMinute++;
      if (selectedMinute > 59) {
        selectedMinute = 0;
      }
      _notifyParent();
      minuteController.jumpToItem(selectedMinute);
    });
  }

  void decrementMinute() {
    setState(() {
      selectedMinute--;
      if (selectedMinute < 0) {
        selectedMinute = 59;
      }
      _notifyParent();
      minuteController.jumpToItem(selectedMinute);
    });
  }

  void incrementPeriod() {
    setState(() {
      selectedPeriodIndex++;
      if (selectedPeriodIndex > 1) {
        selectedPeriodIndex = 0;
      }
      _notifyParent();
      periodController.jumpToItem(selectedPeriodIndex);
    });
  }

  void decrementPeriod() {
    setState(() {
      selectedPeriodIndex--;
      if (selectedPeriodIndex < 0) {
        selectedPeriodIndex = 1;
      }
      _notifyParent();
      periodController.jumpToItem(selectedPeriodIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTimerHour(context),
          Text(
            ':',
            style:
                Theme.of(context).textTheme.titleMedium
          ),
          _buildTimerMinute(context),
          _buildTimerPeriod(context),
        ],
      ),
    );
  }

  Widget _buildTimerPeriod(BuildContext context) {
    return Column(
      children: [
        _buildIncrementButton(
          context,
          () {
            incrementPeriod();
            periodController.animateToItem(
              selectedPeriodIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        SizedBox(
          height: 15,
          width: 100,
          child: CupertinoPicker(
            scrollController: periodController,
            useMagnifier: true,
            magnification: 1.2,
            itemExtent: 25,
            selectionOverlay: Container(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedPeriodIndex = index;
                _notifyParent();
              });
            },
            children: [
              Center(
                child: Text(
                  'AM',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: periodString == 'AM'
                            ? Colors.black
                            : Colors.transparent,
                      ),
                ),
              ),
              Center(
                child: Text(
                  'PM',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: periodString == 'PM'
                            ? Colors.black
                            : Colors.transparent,
                      ),
                ),
              ),
            ],
          ),
        ),
        _buildDecrementButton(
          context,
          () {
            decrementPeriod();
            periodController.animateToItem(
              selectedPeriodIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimerMinute(BuildContext context) {
    return Column(
      children: [
        _buildIncrementButton(
          context,
          () {
            incrementMinute();
            minuteController.animateToItem(
              selectedMinute,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        SizedBox(
          height: 15,
          width: 60,
          child: CupertinoPicker(
            scrollController: minuteController,
            useMagnifier: true,
            magnification: 1.2,
            itemExtent: 25,
            selectionOverlay: Container(),
            onSelectedItemChanged: (index) {
              selectedMinute = index;
              _notifyParent();
            },
            children: List<Widget>.generate(
              60,
              (index) {
                final mintueStr = index.toString().padLeft(2, '0');
                final isSelected = (index == selectedMinute);
                return Center(
                  child: Text(
                    mintueStr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? Colors.black : Colors.transparent,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        _buildDecrementButton(
          context,
          () {
            decrementMinute();
            minuteController.animateToItem(
              selectedMinute,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimerHour(BuildContext context) {
    return Column(
      children: [
        _buildIncrementButton(
          context,
          () {
            incrementHour();
            hourController.animateToItem(
              selectedHour - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        SizedBox(
          height: 15,
          width: 60,
          child: CupertinoPicker(
            scrollController: hourController,
            useMagnifier: true,
            magnification: 1.2,
            itemExtent: 25,
            selectionOverlay: Container(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedHour = index + 1;
                _notifyParent();
              });
            },
            children: List<Widget>.generate(
              12,
              (index) {
                final hour = index + 1;
                final isSelected = (hour == selectedHour);
                return Center(
                  child: Text(
                    '$hour',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected ? Colors.black : Colors.transparent,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        _buildDecrementButton(context, () {
          decrementHour();
          hourController.animateToItem(
            selectedHour - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }),
      ],
    );
  }

  IconButton _buildIncrementButton(
      BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.keyboard_arrow_up_rounded,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ),
    );
  }

  IconButton _buildDecrementButton(
      BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ),
    );
  }
}
