part of 'create_activity.dart';

class _CreateActivityState extends State<CreateActivity> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _updateMessage();

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  Address? _address;

  @protected
  void onLocationClicked<T>() async {
    T? result = await CreateActivityLocationSelector.open(
      onAddressReceived: (address) {
        setState(() {
          _address = address;
          _updateMessage();
        });
      }
    );

    if(result.instanceOf<Address>()) {
      setState(() {
        _address = result as Address;
        _updateMessage();
      });
    }
  }

  List<SelectedMedia> _files = [];

  @protected
  void onImageClicked<T>() async {
    T? result = await Multimedia.open(
      route: "/supportive_images",
      onlyPhoto: true,
      allowMultiple: true,
      onListReceived: _updateMediaWithList,
      onReceived: _updateMediaWithSingle
    );

    if(result.instanceOf<List<SelectedMedia>>()) {
      _updateMediaWithList(result as List<SelectedMedia>);
    } else if(result.instanceOf<SelectedMedia>()) {
      _updateMediaWithSingle(result as SelectedMedia);
    }
  }

  void _updateMediaWithList(List<SelectedMedia> items) {
    setState(() {
      _files = [..._files, ...items];
      _updateMessage();
    });
  }

  void _updateMediaWithSingle(SelectedMedia item) {
    setState(() {
      _files = [..._files, item];
      _updateMessage();
    });
  }

  GoInterest? _interest;

  @protected
  void onInterestClicked<T>() async {
    CreateActivityInterestPicker.open(
      selected: _interest,
      categories: CentreController.data.state.categories.value,
      onSelected: (GoInterest interest) {
        setState(() {
          _interest = interest;
          _updateMessage();
        });
      }
    );
  }

  DateTime? _date;

  @protected
  void onDateClicked<T>() async {
    final DateTime current = DateTime.now();
    final DateTime dateChecker = DateTime(current.year, current.month, current.day - 1);

    DateTime? result = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: current,
      lastDate: DateTime(current.year + 1),
      routeSettings: RouteSettings(name: Navigate.appendRoute("/pick_date")),
    );

    if(result.isNotNull) {
      if(result!.isAfter(dateChecker)) {
        setState(() {
          _date = result;
          _updateMessage();
        });
      } else {
        notify.warn(message: "Date cannot be current or in the past");
      }
    }
  }

  TimeOfDay? _startTime;

  @protected
  void onStartTimeClicked<T>() async {
    final TimeOfDay timeChecker = TimeOfDay.now();

    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: timeChecker,
      routeSettings: RouteSettings(name: Navigate.appendRoute("/pick_start_time"))
    );

    if(result.isNotNull) {
      bool isFuture = _date != null ? _isTimeValidForDate(result!, _date!) : result!.isAfter(timeChecker);

      if(isFuture && (_endTime.isNull || result.isBefore(_endTime!))) {
        setState(() {
          _startTime = result;
          _updateMessage();
        });
      } else {
        notify.warn(message: "Time cannot be current or in the past");
      }
    }
  }

  /// Checks if the selected time is valid considering the selected date.
  bool _isTimeValidForDate(TimeOfDay time, DateTime selected) {
    final DateTime current = DateTime.now();
    final DateTime selectedDateTime = DateTime(selected.year, selected.month, selected.day);
    final DateTime today = DateTime(current.year, current.month, current.day);

    if (selectedDateTime.isAfter(today)) {
      return true;
    } else {
      return time.isAfter(TimeOfDay(hour: current.hour, minute: current.minute));
    }
  }

  TimeOfDay? _endTime;

  @protected
  void onEndTimeClicked<T>() async {
    final TimeOfDay timeChecker = TimeOfDay.now();

    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: timeChecker,
      routeSettings: RouteSettings(name: Navigate.appendRoute("/pick_end_time"))
    );

    if(result.isNotNull) {
      bool isFuture = _date != null ? _isTimeValidForDate(result!, _date!) : result!.isAfter(timeChecker);
      if(isFuture && (_startTime.isNull || result.isAfter(_startTime!))) {
        setState(() {
          _endTime = result;
          _updateMessage();
        });
      } else {
        notify.warn(message: "Time cannot be current or in the past");
      }
    }
  }
  
  @protected
  Color buttonColor(bool change) => change ? CommonColors.instance.color.lighten(20) : CommonColors.instance.color;

  @protected
  void onDeleted(SelectedMedia media) {
    console.log(media);

    setState(() {
      _files.removeWhere((item) => item.path == media.path);
      _updateMessage();
    });
  }

  @protected
  List<ButtonView> get actions => [
    ButtonView(
      header: "Pick an interest",
      icon: Icons.interests,
      color: buttonColor(_interest.isNotNull),
      onClick: onInterestClicked,
      child: _interest.isNotNull ? InterestViewer.view(interest: _interest!) : null
    ),
    ButtonView(
      header: "Select a location",
      icon: Icons.share_location_rounded,
      color: buttonColor(_address.isNotNull),
      onClick: onLocationClicked,
      child: _address.isNotNull ? LocationView(address: _address!) : null,
    ),
    ButtonView(
      header: "Add supportive image",
      body: "false",
      icon: Icons.perm_media_rounded,
      color: buttonColor(_files.isNotEmpty),
      onClick: onImageClicked,
      child: _files.isNotEmpty ? CreateActivityImageViewer(files: _files, onDeleted: onDeleted) : null
    ),
    ButtonView(
      header: "Pick a date",
      icon: Icons.date_range_rounded,
      color: buttonColor(_date.isNotNull),
      onClick: onDateClicked,
    ),
    ButtonView(
      header: "Select start time",
      icon: Icons.time_to_leave_rounded,
      color: buttonColor(_startTime.isNotNull),
      onClick: onStartTimeClicked,
    ),
    ButtonView(
      header: "Select an end time",
      icon: Icons.timer_rounded,
      color: buttonColor(_endTime.isNotNull),
      onClick: onEndTimeClicked,
    ),
  ];

  @protected
  String get message {
    if (_interest.isNull) return "I haven't planned anything yet.";

    String message = "I will be";

    // Construct the activity part of the sentence
    message += " ${_interest!.verb} ${_interest!.name}";

    // Location
    if (_address.isNotNull) {
      message += " at ${_address!.place}";
    }

    // Date & Time
    if (_date.isNotNull) {
      String formattedStart = CommonUtility.formatDay(_date!, showTime: false);
      message += " on $formattedStart";
    }

    if (_startTime.isNotNull) {
      message += " starting from ${_startTime!.format(context)}";
    }

    if (_endTime.isNotNull) {
      message += " and ending at ${_endTime!.format(context)}";
    }

    return "${message.trim()}.";
  }

  void _updateMessage() {
    _textController.text = message;
  }

  @protected
  bool get canCreate => _interest.isNotNull && _address.isNotNull && _textController.text.isNotEmpty
    && _startTime.isNotNull && _endTime.isNotNull && _date.isNotNull;

  void _create() async {
    if(canCreate) {
      GoCreate create = GoCreate(
        message: message,
        date: _date!,
        interest: _interest!.id,
        name: _interest!.name,
        emoji: _interest!.emoji,
        location: _address!,
        images: _files,
        startTime: _startTime!.create(),
        endTime: _endTime!.create()
      );

      ActivityLifeCycle.onGoCreate(create);
      Navigator.pop(context);
    } else {
      notify.tip(message: "Please complete all fields", color: CommonColors.instance.bluish);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.all(2),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BannerAdLayout(
        mainAxisSize: MainAxisSize.min,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                GoBack(onTap: () => Navigate.close(closeAll: false)),
                TextBuilder(
                  text: "Create a nearby activity",
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
                Spacing.flexible(),
                if(canCreate) ...[
                  TextButton(
                    onPressed: _create,
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        return CommonColors.instance.bluish.lighten(48);
                      }),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
                    ),
                    child: TextBuilder(
                      text: "Create",
                      weight: FontWeight.bold,
                      color: CommonColors.instance.bluish
                    )
                  ),
                ],
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Field(
                      hint: "I will be playing basketball with my friends at Johnson Street, Abuja by 5:00pm today.",
                      needLabel: true,
                      replaceHintWithLabel: false,
                      useBigField: true,
                      enabled: canCreate,
                      label: "Descriptive message (Optional)",
                      inputConfigBuilder: (config) => config.copyWith(
                        labelColor: Theme.of(context).primaryColor,
                        labelSize: 14
                      ),
                      inputDecorationBuilder: (dec) => dec.copyWith(
                        enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                        focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                        disabledBorderSide: BorderSide(color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.grey),
                      ),
                      onTapOutside: (activity) => CommonUtility.unfocus(context),
                      controller: _textController,
                    ),
                    ...actions.map((view) {
                      if(view.child.isNotNull) {
                        return view.child!;
                      } else {
                        return SizedBox.shrink();
                      }
                    })
                  ],
                )
              )
            ),
            Wrap(
              runAlignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: actions.map((view) => CreateActivityButton(view: view)).toList(),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CommonColors.instance.bluish,
                borderRadius: BorderRadius.circular(12)
              ),
              child: TextBuilder(
                text: "Supportive images can be location, activity pictures and so forth.",
                size: 12,
                color: CommonColors.instance.lightTheme
              )
            ),
          ],
        ),
      ),
    );
  }
}

extension on TimeOfDay {
  GoCreateTime create() {
    return GoCreateTime(hour: hour, minute: minute);
  }
}