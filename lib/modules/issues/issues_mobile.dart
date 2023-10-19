part of issues_view;

class _IssuesMobile extends StatefulWidget {
  @override
  __IssuesMobileState createState() => __IssuesMobileState();
}

class __IssuesMobileState extends State<_IssuesMobile> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IssuesViewModel>.reactive(
        viewModelBuilder: () => IssuesViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load());
        },
        builder: (context, model, child) => model.busy
            ? BackgroundPattern(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                SizedBox(
                  height: 100.w,
                ),
                Center(
                    child: Image.asset(
                  AppTheme.instance.brandLogo,
                  width: 140.w,
                )),
                SizedBox(
                  height: 40.w,
                ),
                CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                )
              ])))
            : BackgroundPattern(
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: model.issues.length == 0
                          ? Center(
                              child: Text(
                                'No more issues',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 10.h),
                              ),
                            )
                          : ListView.builder(
                              itemCount: model.issues.length,
                              itemBuilder: (context, i) => _issueCard(
                                    model: model,
                                    issueId: model.issues[i].id,
                                    issueSubject: model.issues[i].subject,
                                    issueDescribe: model.issues[i].describe,
                                    issueCreatedAt: model.issues[i].createdAt,
                                  )),
                    ),
                    _navigationButtons(model),
                  ],
                ),
              ));
  }

  Widget _issueCard(
      {String issueSubject,
      String issueDescribe,
      Timestamp issueCreatedAt,
      String issueId,
      IssuesViewModel model}) {
    final convertedDate = DateTime.fromMillisecondsSinceEpoch(
        issueCreatedAt.millisecondsSinceEpoch);
    final formatedDate = DateFormat('d/M/y').format(convertedDate);
    return Column(
      children: [
        GestureDetector(
          onTap: () => null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _issueTitle(
                        title: 'Issue subject ',
                        value: issueSubject,
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: _issueTitle(
                            title: 'Created: ', value: formatedDate))
                  ],
                ),
                SizedBox(height: 10.h),
                _issueTitle(title: 'Describe: ', value: issueDescribe)
              ],
            ),
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _navigationButtons(IssuesViewModel model) {
    Color _prevButtonColor =
        model.prevExist ? AppTheme.instance.primaryColorBlue : Colors.grey;
    Color _nextButtonColor =
        model.nextExist ? AppTheme.instance.primaryColorBlue : Colors.grey;
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap:
                model.prevExist ? () => model.paginatedProperties(false) : null,
            child: Container(
              height: 30.w,
              width: 35.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5)),
                  border: Border.all(color: _prevButtonColor, width: 2.w)),
              child: Center(
                child: Icon(
                  Icons.chevron_left,
                  color: _prevButtonColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          InkWell(
            onTap:
                model.nextExist ? () => model.paginatedProperties(true) : null,
            child: Container(
              height: 30.w,
              width: 35.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border.all(color: _nextButtonColor, width: 2.w)),
              child: Center(
                  child: Icon(
                Icons.chevron_right,
                color: _nextButtonColor,
              )),
            ),
          ),
        ],
      ),
    );
  }

  RichText _issueTitle(
      {String title = '', String value = '', Color titleColor = Colors.black}) {
    return RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: value,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal))
        ]));
  }

  Widget _divider() {
    return Divider(
      thickness: 0.8.w,
      height: 0.8.w,
      color: AppTheme.instance.primaryDarker,
    );
  }
}
