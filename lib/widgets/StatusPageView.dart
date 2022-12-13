import 'package:flutter/material.dart';

class StatusPageView extends StatefulWidget {
  final List<StoryItem> storiesMapList;
  final int storyNumber;
  final TextStyle fullPagetitleStyle;

  /// Choose whether progress has to be shown
  final bool displayProgress;

  /// Color for visited region in progress indicator
  final Color fullpageVisitedColor;

  /// Color for non visited region in progress indicator
  final Color fullpageUnvisitedColor;

  /// Whether image has to be show on top left of the page
  final bool showThumbnailOnFullPage;

  /// Size of the top left image
  final double fullpageThumbnailSize;

  /// Whether image has to be show on top left of the page
  final bool showStoryNameOnFullPage;

  /// Status bar color in full view of story
  final Color storyStatusBarColor;

  final Function storyChanged;

  StatusPageView({
    Key key,
    @required this.storiesMapList,
    @required this.storyNumber,
    this.fullPagetitleStyle,
    this.displayProgress,
    this.fullpageVisitedColor,
    this.fullpageUnvisitedColor,
    this.showThumbnailOnFullPage,
    this.fullpageThumbnailSize,
    this.showStoryNameOnFullPage,
    this.storyStatusBarColor,
    this.storyChanged,
  }) : super(key: key);

  @override
  FullPageViewState createState() => FullPageViewState();
}

class FullPageViewState extends State<StatusPageView> {
  List<StoryItem> storiesMapList;
  int storyNumber;
  List<Widget> combinedList;
  List listLengths;
  int selectedIndex;
  PageController _pageController;
  bool displayProgress;
  Color fullpageVisitedColor;
  Color fullpageUnvisitedColor;
  bool showThumbnailOnFullPage;
  double fullpageThumbnailSize;
  bool showStoryNameOnFullPage;
  Color storyStatusBarColor;

  nextPage(index) {
    if (index == combinedList.length - 1) {
      //Navigator.pop(context);
      return;
    }

    widget.storyChanged(index);

    setState(() {
      selectedIndex = index + 1;
    });

    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  prevPage(index) {
    if (index == 0) return;

    widget.storyChanged(index);

    setState(() {
      selectedIndex = index - 1;
    });
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  @override
  void initState() {
    storiesMapList = widget.storiesMapList;
    storyNumber = widget.storyNumber;

    combinedList = getStoryList(storiesMapList);
    listLengths = getStoryLengths(storiesMapList);
    selectedIndex = getInitialIndex(storyNumber, storiesMapList);

    displayProgress = widget.displayProgress ?? true;
    fullpageVisitedColor = widget.fullpageVisitedColor;
    fullpageUnvisitedColor = widget.fullpageUnvisitedColor;
    showThumbnailOnFullPage = widget.showThumbnailOnFullPage;
    fullpageThumbnailSize = widget.fullpageThumbnailSize;
    showStoryNameOnFullPage = widget.showStoryNameOnFullPage ?? true;
    storyStatusBarColor = widget.storyStatusBarColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: selectedIndex);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (page) {
              widget.storyChanged(page);
              setState(() {
                selectedIndex = page;
              });
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              combinedList.length,
              (index) => Stack(
                children: <Widget>[
                  Scaffold(
                    body: combinedList[index],
                  ),
                  // Overlay to detect taps for next page & previous page
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            prevPage(index);
                          },
                          child: Center(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            nextPage(index);
                          },
                          child: Center(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The progress of story indicator
          Column(
            children: <Widget>[
              Container(
                color: storyStatusBarColor ?? Colors.black,
                child: SafeArea(
                  child: Center(),
                ),
              ),
              displayProgress
                  ? Row(
                      children: List.generate(
                            numOfCompleted(listLengths, selectedIndex),
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.all(2),
                                height: 2.5,
                                decoration: BoxDecoration(
                                    color: fullpageVisitedColor ??
                                        Color(0xff444444),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                      )
                                    ]),
                              ),
                            ),
                          ) +
                          List.generate(
                            (getCurrentLength(listLengths, selectedIndex) -
                                numOfCompleted(listLengths, selectedIndex)),
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.all(2),
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: widget.fullpageUnvisitedColor ??
                                      Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(blurRadius: 2)],
                                ),
                              ),
                            ),
                          ),
                    )
                  : Center(),
            ],
          ),
        ],
      ),
    );
  }
}

List<Widget> getStoryList(List<StoryItem> storiesMapList) {
  List<Widget> imagesList = [];
  for (int i = 0; i < storiesMapList.length; i++)
    for (int j = 0; j < storiesMapList[i].stories.length; j++)
      imagesList.add(storiesMapList[i].stories[j]);
  return imagesList;
}

List<int> getStoryLengths(List<StoryItem> storiesMapList) {
  List<int> intList = [];
  int count = 0;
  for (int i = 0; i < storiesMapList.length; i++) {
    count = count + storiesMapList[i].stories.length;
    intList.add(count);
  }
  return intList;
}

int getCurrentLength(List<int> listLengths, int index) {
  index = index + 1;
  int val = listLengths[0];
  for (int i = 0; i < listLengths.length; i++) {
    val = i == 0 ? listLengths[0] : listLengths[i] - listLengths[i - 1];
    if (listLengths[i] >= index) break;
  }
  return val;
}

numOfCompleted(List<int> listLengths, int index) {
  index = index + 1;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    val = listLengths[i];
  }
  return (index - val);
}

getInitialIndex(int storyNumber, List<StoryItem> storiesMapList) {
  int total = 0;
  for (int i = 0; i < storyNumber; i++) {
    total += storiesMapList[i].stories.length;
  }
  return total;
}

int getStoryIndex(List<int> listLengths, int index) {
  index = index + 1;
  int temp = 0;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    if (temp != listLengths[i]) val += 1;
    temp = listLengths[i];
  }
  return val;
}

class StoryItem {
  /// List of pages to display as stories under this story
  List<Widget> stories;

  /// Add a story
  StoryItem({@required this.stories});
}
