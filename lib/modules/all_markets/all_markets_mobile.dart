part of all_markets_view;

class __AllMarketsMobileState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllMarketsViewModel>.reactive(
        viewModelBuilder: () => AllMarketsViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => model.loading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : BackgroundPattern(
                child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Market Name:',
                        style: AppTheme.instance.textStyleSmall(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000).withOpacity(1))),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    if (model.markets.length > 0) _listMarkets(model),
                    if (model.markets.length == 0)
                      Expanded(
                        child: Center(
                            child: Text("Nothing to show",
                                style: AppTheme.instance.textStyleSmall())),
                      ),
                    _buttons(model),
                  ],
                ),
              )));
  }

  Expanded _listMarkets(AllMarketsViewModel model) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: model.markets
            .map((e) => model.markets.length == 1
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.instance.colorGreyLight,
                            width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: market(e, model),
                  )
                : e == model.markets.first
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.instance.colorGreyLight,
                                width: 2.0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        child: market(e, model),
                      )
                    : e == model.markets.last
                        ? ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppTheme.instance.colorGreyLight,
                                        width: 2.0),
                                    left: BorderSide(
                                        color: AppTheme.instance.colorGreyLight,
                                        width: 2.0),
                                    right: BorderSide(
                                        color: AppTheme.instance.colorGreyLight,
                                        width: 2.0)),
                              ),
                              child: market(e, model),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: e != model.markets.first &&
                                      e != model.markets.last
                                  ? Border(
                                      bottom: BorderSide(
                                          color:
                                              AppTheme.instance.colorGreyLight,
                                          width: 2.0),
                                      left: BorderSide(
                                          color:
                                              AppTheme.instance.colorGreyLight,
                                          width: 2.0),
                                      right: BorderSide(
                                          color:
                                              AppTheme.instance.colorGreyLight,
                                          width: 2.0))
                                  : Border.symmetric(
                                      vertical: BorderSide(
                                          color:
                                              AppTheme.instance.colorGreyLight,
                                          width: 2.0)),
                            ),
                            child: market(e, model),
                          ))
            .toList(),
      ),
    ));
  }

  Container market(MarketModel data, AllMarketsViewModel model) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(children: [
        Text('${data.name}, ${data.state}',
            style: AppTheme.instance
                .textStyleSmall(color: Color(0xff000000).withOpacity(1))),
        Spacer(),
        InkWell(
          onTap: () {
            model.removeMarket(data);
          },
          child: Icon(
            Icons.remove_circle_outline,
            size: 20.0,
          ),
        )
      ]),
    );
  }

  ButtonsChoose _buttons(AllMarketsViewModel model) {
    return ButtonsChoose(
      buttons: [
        ButtonsChooseModel(
            margin: EdgeInsets.only(left: 15.0.w),
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 20.0,
              color: Colors.white,
            ),
            title: Text('Add New Market',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.instance.primaryColorBlue)),
            function: () {
              model.goToAddMarkets();
            }),
        ButtonsChooseModel(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: 23.0,
              color: Color(0XFF606060),
            ),
            title: Text('Back',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Color(0XFF606060))),
            function: () {
              model.goToHome();
            }),
        ButtonsChooseModel(
            borderColor: model.marketsRemoved.isEmpty
                ? Colors.transparent
                : Color(0XFF606060),
            icon: model.busy
                ? CircularProgressIndicator()
                : Icon(
                    Icons.done,
                    size: 23.0,
                    color: model.marketsRemoved.isEmpty
                        ? Colors.transparent
                        : Color(0XFF606060),
                  ),
            title: Text('Complete',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600,
                    color: model.marketsRemoved.isEmpty
                        ? Colors.transparent
                        : Color(0XFF606060))),
            function: model.marketsRemoved.isEmpty
                ? null
                : () async {
                    if (!model.busy) {
                      if (await model.removeMarketsDatabase()) {
                        ScaffoldMessenger.of(locator<DialogService>()
                                .scaffoldKey
                                .currentContext)
                            .showSnackBar(SnackBar(
                          content: Text('Markets deleted'),
                        ));
                      } else {
                        {
                          ScaffoldMessenger.of(locator<DialogService>()
                                  .scaffoldKey
                                  .currentContext)
                              .showSnackBar(SnackBar(
                            content: Text('No uploaded data'),
                          ));
                        }
                      }
                    }
                  }),
      ],
    );
  }
}
