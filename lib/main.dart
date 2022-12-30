import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 광고
import 'dart:math'; // Random 함수 사용

void main() {
  //광고 초기화
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(     MaterialApp(
    title: 'Navigator',
    home: Activity_main(),
  ),
  );
}

class Activity_main extends StatefulWidget {
  const Activity_main({Key? key}) : super(key: key);

  @override
  State<Activity_main> createState() => _Activity_mainState();
}
class _Activity_mainState extends State<Activity_main> {

  //전면광고 설정
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  //리워드 광고 설정
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  late int ad_count ;

  @override
  void initState() {
    super.initState();
    ad_count =100 ; // 광고 입장권
    _createInterstitialAd();
    _createRewardedAd();
  }
  final BannerAd banner = BannerAd(
    listener: BannerAdListener(
      onAdLoaded: (Ad ad)  => debugPrint('Ad loaded'), // 220611 변경 및 확인
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        debugPrint('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
      onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
      onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
    ),
    size: AdSize.banner,
    adUnitId: "ca-app-pub-9818894618687698/2178383306", // 내아이디 - 광고 확인(221231추가완료)
    // adUnitId: "ca-app-pub-3940256099942544/6300978111", // Testid
    // 주석추가추가 for ad

    request: AdRequest(),
  )..load();
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId:'ca-app-pub-9818894618687698/6468982100', // 내아이디 221231 확인
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad 전면광고 실행됨');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('전면광고 에러남: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-9818894618687698/8604190857', // 내아이디 221231
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }
  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('보상형광고가 실행되었습니다.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('보상형광고가 종료되었습니다.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('보상형광고가 실행안됨: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('리워드 받음');
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    }
    );



    ///???
    // _rewardedAd!.show(onUserEarnedReward: (ad, RewardItem rewardItem) {
    //   ad_count = 10 ;
    //   print('${ad_count} 의 입장권 획득');
    // });
    ///???



    _rewardedAd = null;
  }

  var color_black = Color.fromRGBO(0, 0, 0, 1.0) ; // 검정
  var color_navy = Color.fromRGBO(53, 66, 89, 1.0) ; // 남색
  var color_theme = Color.fromRGBO(255, 246, 233, 1.0) ; // 메인색상
  var color_yellow = Color.fromRGBO(255, 246, 233, 1.0) ; // 노랑
  var color_blue = Color.fromRGBO(234, 244, 255, 1.0) ;  // 파란색
  var color_red = Color.fromRGBO(251, 233, 255, 1.0);// 빨간색
  var color_red2 = Color.fromRGBO(231, 18, 47, 1.0);// 빨간색
  var color_gray1 = Color.fromRGBO(144, 144, 144, 1.0); //회색1
  var color_gray2 = Color.fromRGBO(127, 118, 120, 10.0); //회색2


  @override
  Widget build(BuildContext context) {
    var random_index = Random();

    return MaterialApp(
      //글자 크기 고정용
      builder: (context, child) {return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: child!,
      );},
      //디버그 표시를 없앤다.
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        // appBar: AppBar(title: Text("일반기계기사 공식 by 공남아") , backgroundColor: color_navy),
          body: ListView(
            children: [
              Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/main_image.jpg'), // 배경 이미지
                    ),
                  ),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("일반기계기사",style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        )),
                        SizedBox(height: 10,),
                        Text("공식 암기",style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("입장권 : ",style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )),
                            Text("${ad_count}",style: TextStyle(
                              backgroundColor: Colors.white,
                              color: color_red2,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                            SizedBox(width: 10,),
                          ],
                        ),
                        SizedBox(height: 5,),
                      ])
              ), // 배경 이미지
              ListTile(
                tileColor: color_yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    )),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.abc,
                        color: color_navy,
                        size: 50.0,
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("공식 목록",style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                            color: color_black,
                          )
                          ),
                          SizedBox(height: 10),
                          Text("필기 시험에 필요한 공식을 확인해보세요",style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            color: color_gray2,
                          )
                          ),
                          SizedBox(height: 10),

                        ],
                      )

                    ],
                  ),
                ),
                onTap: (){
                  /*
                  if(ad_count>=1){
                    if(random_index.nextInt(100)%5==0){
                      _showInterstitialAd();
                      print('시도횟수 : ${_numInterstitialLoadAttempts}');
                    }
                    setState((){
                      ad_count = ad_count-1 ;
                    }
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context_main) => Category()));
                    debugPrint("위험물 목록 페이지가 실행되었습니다.");
                  }
                  else{
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Text("광고를 시청하시겠습니까?"),
                          actions: [
                            FloatingActionButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  _showRewardedAd();
                                  setState((){
                                    ad_count = 100 ;
                                  }
                                  );
                                },
                                child: Text("예") ),
                            FloatingActionButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text("아니오") ),
                          ],
                        );
                      },
                    );
                  }*/
                },

              ),//공식목록
              SizedBox(height: 10),
              ListTile(
                tileColor: color_yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    )),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.search_outlined,
                        color: color_navy,
                        size: 50.0,
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("공식 검색",style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                            color: color_black,
                          )
                          ),
                          SizedBox(height: 10),
                          Text("공식을 검색해 보세요.",style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            color: color_gray2,
                          )
                          ),
                          SizedBox(height: 10),

                        ],
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  /*
                  if(ad_count>=1){
                    if(random_index.nextInt(100)%5==0){
                      _showInterstitialAd();
                      print('시도횟수 : ${_numInterstitialLoadAttempts}');
                    }
                    setState((){
                      ad_count = ad_count-1 ;
                    }
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context_main) => Category()));
                    debugPrint("위험물 목록 페이지가 실행되었습니다.");
                  }
                  else{
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Text("광고를 시청하시겠습니까?"),
                          actions: [
                            FloatingActionButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  _showRewardedAd();
                                  setState((){
                                    ad_count = 100 ;
                                  }
                                  );
                                },
                                child: Text("예") ),
                            FloatingActionButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text("아니오") ),
                          ],
                        );
                      },
                    );
                  }*/
                },
              ),//공식검색
              SizedBox(height: 10),
              ListTile(
                tileColor: color_yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    )),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.text_snippet_outlined,
                        color: color_navy,
                        size: 50.0,
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("기출연습",style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                            color: color_black,
                          )
                          ),
                          SizedBox(height: 10),
                          Text("공식을 적용해 보세요",style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            color: color_gray2,
                          )
                          ),
                          SizedBox(height: 10),

                        ],
                      )

                    ],
                  ),
                ),
                onTap: (){},
              ),//기출연습
              SizedBox(height: 10),
              ListTile(
                tileColor: color_yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    )),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.question_mark_outlined,
                        color: color_navy,
                        size: 50.0,
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("공부방법",style: TextStyle(
                            fontSize:25,
                            fontWeight: FontWeight.bold,
                            color: color_black,
                          )
                          ),
                          SizedBox(height: 10),
                          Text("어떻게 공부하는 것이 좋을까요?",style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            color: color_gray2,
                          )
                          ),
                          SizedBox(height: 10),

                        ],
                      ),
                    ],
                  ),
                ),
                onTap: (){},
              ),//공부방법
              SizedBox(height: 10),

            ],
          ),
          bottomNavigationBar: Container(
            alignment: Alignment.center,
            height: banner.size.height.toDouble(),
            // height: 65,
            child: AdWidget(ad:banner),
          )

      ),

    ) ;
  }
}


// 광고 시도 관련 전역변수
const int maxFailedLoadAttempts = 3;