import 'package:blt/src/models/contributors_model.dart';
import 'package:blt/src/models/project_model.dart';
import 'package:blt/src/pages/drawer/drawer_imports.dart';
import 'package:blt/src/util/api/github_apis.dart';

class ContributorsPage extends StatefulWidget {
  const ContributorsPage({super.key});

  @override
  State<ContributorsPage> createState() => _ContributorsPageState();
}

ScrollController _scrollController = new ScrollController();

class _ContributorsPageState extends State<ContributorsPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  List<Project> projects = [
    Project(
      owner: "OWASP-BLT",
      name: "BLT",
      desc:
          "OWASP-BLT BLT is a bug logging tool to report issues and get points, companies are held accountable.",
      logoUrl: "https://avatars.githubusercontent.com/u/160347863?s=48&v=4",
    ),
    Project(
      owner: "OWASP-BLT",
      name: "BLT-FLutter",
      desc: "The official OWASP BLT App repository/ Heist 'em bugs!",
      logoUrl: "https://avatars.githubusercontent.com/u/160347863?s=48&v=4",
    ),
    Project(
      owner: "OWASP-BLT",
      name: "BLT-Bacon",
      desc:
          "Bacon is a OWASP BLT Private Chain based on POA consensus that rewards bug testers",
      logoUrl: "https://avatars.githubusercontent.com/u/160347863?s=48&v=4",
    )
  ];
  @override
  void initState() {
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: isDarkMode
          ? Color.fromRGBO(34, 22, 23, 1)
          : Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? Color.fromRGBO(58, 21, 31, 1) : Color(0xFFDC4654),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Projects",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                color: isDarkMode
                    ? Color.fromRGBO(34, 22, 23, 1)
                    : Theme.of(context).canvasColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text(
                        "Projects",
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                            color: Color(0xFF737373),
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Text(
                        "Check out the list of awesome projects we have. Maybe contribute and become a contributor too?",
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Color(0xFF737373),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.008),
              ListView.separated(
                shrinkWrap: true,
                itemCount: projects.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    SizedBox(height: size.height * 0.025),
                itemBuilder: (context, index) {
                  return PojectsSection(project: projects[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PojectsSection extends StatefulWidget {
  const PojectsSection({super.key, required this.project});
  final Project project;

  @override
  State<PojectsSection> createState() => _PojectsSectionState();
}

class _PojectsSectionState extends State<PojectsSection> {
  List<Contributors> contributors = [];

  void getContributors() async {
    contributors = await GithubApis.getContributors(
      widget.project.name,
      widget.project.owner,
    );
    setState(() {});
  }

  CircleAvatar buildAvatar(String partUrl) {
    try {
      if (partUrl == "")
        return CircleAvatar(
          foregroundColor: Colors.transparent,
          radius: 20,
          child: Icon(
            Icons.account_circle_outlined,
            color: Color(0xFFDC4654),
            size: 40,
          ),
        );
      else
        return CircleAvatar(
          foregroundImage: CachedNetworkImageProvider(partUrl),
          radius: 20,
        );
    } on Exception {
      return CircleAvatar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.account_circle_outlined,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }

  @override
  void initState() {
    getContributors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(imageUrl: widget.project.logoUrl),
              ),
            ),
            SizedBox(width: 5),
            Text(
              widget.project.name,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: Color(0xFFDC4654),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          widget.project.desc,
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              color: Color(0xFF737373),
            ),
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: size.height * 0.015),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteManager.contributorInfo,
              arguments: contributors,
            );
          },
          child: Container(
            height: size.height * 0.07,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromARGB(255, 250, 247, 241),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Color.fromARGB(255, 200, 200, 200),
                  spreadRadius: 0.1,
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Contributors",
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          color: Color(0xFFDC4654),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          (contributors.length > 3) ? 3 : contributors.length,
                      itemBuilder: (context, index) => CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          contributors[index].image,
                        ),
                        radius: size.width * 0.045,
                      ),
                      separatorBuilder: (context, index) => SizedBox(width: 4),
                    ),
                    if (contributors.length > 3) ...[
                      SizedBox(width: 5),
                      Text(
                        "+${contributors.length - 3} others",
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                            color: Color(0xFFDC4654),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFDC4654),
                  size: 20,
                )
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}
